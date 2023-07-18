//
//  EditIntakeViewModel.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 18.07.23.
//

import Foundation
import CoreData

final class EditIntakeViewModel: ObservableObject {
    @Published var intake: Intake
    
    private let context: NSManagedObjectContext
    
    init(provider: IntakesProvider, intake: Intake? = nil) {
        self.context = provider.newContext
        self.intake = Intake(context: self.context)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
