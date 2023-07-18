//
//  IntakesProvider.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 18.07.23.
//

import Foundation
import CoreData

final class IntakesProvider {
    static let shared = IntakesProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "IntakesDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
    
}
