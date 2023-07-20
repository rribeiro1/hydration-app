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
    
    private let provider: IntakesProvider
    private let context: NSManagedObjectContext
    
    init(provider: IntakesProvider, intake: Intake? = nil) {
        self.provider = provider
        self.context = provider.newContext
        if let intake,
           let existingIntakeCopy = provider.exists(intake, in: context) {
            self.intake = existingIntakeCopy
        } else {
            self.intake = Intake(context: self.context)
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}
