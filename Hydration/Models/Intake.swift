//
//  Intake+CoreDataProperties.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 18.07.23.
//
//

import Foundation
import CoreData


import Foundation
import CoreData

final class Intake: NSManagedObject, Identifiable {
    @NSManaged var ammount: Int
    @NSManaged var type: String
    @NSManaged var time: Date

    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date.now, forKey: "time")
    }
}

extension Intake {
    private static var intakesFetchRequest: NSFetchRequest<Intake> {
        NSFetchRequest(entityName: "Intake")
    }
    
    static func all() -> NSFetchRequest<Intake> {
        let request: NSFetchRequest<Intake> = intakesFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Intake.time, ascending: false)
        ]
        return request
    }
}
