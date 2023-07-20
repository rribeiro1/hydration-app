//
//  IntakesProvider.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 18.07.23.
//

import Foundation
import CoreData
import SwiftUI

final class IntakesProvider {
    static let shared = IntakesProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "IntakesDataModel")
        
        if EnvironmentValues.isPreview {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
    func exists(_ intake: Intake, in context: NSManagedObjectContext) -> Intake? {
        try? context.existingObject(with: intake.objectID) as? Intake
    }
    
    func delete(_ intake: Intake, in context: NSManagedObjectContext) throws {
        if let existingIntake = exists(intake, in: context) {
            context.delete(existingIntake)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

extension EnvironmentValues {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
