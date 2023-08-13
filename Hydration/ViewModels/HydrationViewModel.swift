//
//  HydrationViewModel.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 22.07.23.
//

import Foundation
import CoreData

final class HydrationViewModel: ObservableObject {
    private let viewContext = HydrationProvider.shared.viewContext
    @Published private(set) var intakes: [Intake] = []

    @Published var showAlert: Bool = false
    @Published private(set) var alertTitle: String = ""
    @Published private(set) var alertMessage: String = ""
    @Published private(set) var isLoading = false

    func fetchIntakes() {
        let request = NSFetchRequest<Intake>(entityName: "Intake")
        
        // Create a predicate to filter intakes from today's date.
        let predicate = NSPredicate(format: "time >= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
        let sort = NSSortDescriptor(key: "time", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sort]

        if let intakes = try? viewContext.fetch(request) {
            self.intakes = intakes
        }
    }

    func createIntake(amount: Int, type: IntakeType) {
        let intake = Intake(context: viewContext)
        intake.amount = amount
        intake.type = type.rawValue
        intake.time = Date()
        persist()
    }

    func delete(at offsets: IndexSet) {
        for index in offsets {
            let intake = intakes[index]
            viewContext.delete(intake)
            objectWillChange.send()
        }
        persist()
    }

    func exists(_ intake: Intake) -> Intake? {
        try? viewContext.existingObject(with: intake.objectID) as? Intake
    }
    
    private func persist() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
            self.fetchIntakes()
        } catch {
            print("Error saving!")
        }
    }

    @MainActor
    func logIntakes() async {
        isLoading.toggle()
        defer { isLoading.toggle() }
        let intakesToProcess = self.intakes.filter { intake in
            !intake.processed
        }
        do {
            try await HealthKitService.shared.saveData(intakesToProcess)
            for intake in intakesToProcess {
                intake.processed = true
            }
            persist()
            setAlert(title: "Good work!", message: "Your water consumption data was pushed to Health app!")
        } catch {
            setAlert(title: "Something went wrong!", message: "We couldn't send your water intakes to Health, reason: \(error.localizedDescription)")
            print("Error while saving data to Health")
        }
    }
    
    @MainActor
    func logIntake(intake: Intake) async {
        do {
            try await HealthKitService.shared.saveData([intake])
            intake.processed = true
            persist()
        } catch {
            setAlert(title: "Something went wrong!", message: "We couldn't send your water intakes to Health, reason: \(error.localizedDescription)")
        }
    }

    @MainActor
    func requestAccess() async {
        isLoading.toggle()
        defer { isLoading.toggle() }
        do {
            try await HealthKitService.shared.requestAuthorization()
        } catch {
            print("Error while requesting access to Health")
        }
    }

    @MainActor
    func setAlert(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}
