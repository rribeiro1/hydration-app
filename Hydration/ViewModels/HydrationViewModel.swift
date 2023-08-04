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

    @Published var goal: Int = 3000 { didSet {updateProgress()} }
    @Published private(set) var intakes: [Intake] = [] { didSet {updateProgress()} }
    @Published private(set) var progress: Float = 0.0
    @Published private(set) var intakesAmount: Int = 0

    @Published var showAlert: Bool = false
    @Published private(set) var alertTitle: String = ""
    @Published private(set) var alertMessage: String = ""
    @Published private(set) var isLoading = false

    private func updateProgress() {
        self.intakesAmount = intakes.reduce(0, { $0 + $1.amount })
        self.progress = Float(intakesAmount) / Float(goal)
    }

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

    func fetchGoal() {
        self.goal = getOrCreateUser().goal
    }

    func saveGoal(goal: Int) {
        getOrCreateUser().goal = goal
        persist()
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
        
        // TODO: delete
        await try! Task.sleep(nanoseconds: 5000000000)
        
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

extension HydrationViewModel {
    private func getOrCreateUser() -> User {
        return getUser() ?? createUser(goal: 3000)
    }

    private func getUser() -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1

        do {
            let users = try viewContext.fetch(request)
            return users.first
        } catch {
            print("DEBUG: Some error occured while fetching: \(error)")
            return nil
        }
    }

    private func createUser(goal: Int) -> User {
        let user = User(context: viewContext)
        user.goal = goal
        persist()
        return user
    }
}
