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

    @Published var goal: Int = 3000 {
        didSet {
            updateProgress()
        }
    }
    @Published var intakes: [Intake] = [] {
        didSet {
            updateProgress()
        }
    }
    @Published var progress: Float = 0.0
    @Published var intakesAmmount: Int = 0

    init() {
        fetchGoal()
        fetchIntakes()
    }

    private func updateProgress() {
        self.intakesAmmount = intakes.reduce(0, { $0 + $1.ammount })
        self.progress = Float(intakesAmmount) / Float(goal)
    }

    private func fetchIntakes() {
        let request = NSFetchRequest<Intake>(entityName: "Intake")
        
        // Create a predicate to filter intakes from today's date.
        let predicate = NSPredicate(format: "time >= %@", Calendar.current.startOfDay(for: Date()) as NSDate)
        request.predicate = predicate

        do {
            intakes = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Some error occured while fetching")
        }
    }

    private func fetchGoal() {
        self.goal = getOrCreateUser().goal
    }

    func saveGoal(goal: Int) {
        getOrCreateUser().goal = goal
        save()
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
            save()
        }
    }

    func exists(_ intake: Intake) -> Intake? {
        try? viewContext.existingObject(with: intake.objectID) as? Intake
    }
    
    func save() {
        do {
            try viewContext.save()
            fetchIntakes()
            print("Item was saved")
        } catch {
            print("Error saving!")
        }
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
        save()
        return user
    }
}
