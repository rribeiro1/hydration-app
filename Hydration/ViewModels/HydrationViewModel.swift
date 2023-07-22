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
    
    @Published var intakes: [Intake] = [] {
        didSet {
            updateProgress()
        }
    }
    @Published var goal: Int = 3000 {
        didSet {
            updateProgress()
        }
    }
    @Published var progress: Float = 0.0
    @Published var intakesAmmount: Int = 0

    init() {
        fetchIntakes()
    }

    func updateProgress() {
        self.intakesAmmount = intakes.reduce(0, { $0 + $1.ammount })
        self.progress = Float(intakesAmmount) / Float(goal)
    }

    func fetchIntakes() {
        let request = NSFetchRequest<Intake>(entityName: "Intake")

        do {
            intakes = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Some error occured while fetching")
        }
    }

    func createIntake(ammount: Int, type: IntakeType) {
        let intake = Intake(context: viewContext)
        intake.ammount = ammount
        intake.type = type.rawValue
        intake.time = Date()
        save()
    }
    
    func delete(_ intake: Intake) {
        if let existingIntake = exists(intake) {
            viewContext.delete(existingIntake)
            Task(priority: .background) {
                await viewContext.perform {
                    self.save()
                }
            }
        }
    }
    
    func exists(_ intake: Intake) -> Intake? {
        try? viewContext.existingObject(with: intake.objectID) as? Intake
    }
    
    func save() {
        do {
            try viewContext.save()
            fetchIntakes()
        } catch {
            print("Error saving!")
        }
    }
}
