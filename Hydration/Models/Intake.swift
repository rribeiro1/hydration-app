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
    
    var intakeType: IntakeType {
        get {
            return IntakeType(rawValue: type) ?? .water
        }
        set {
            type = newValue.rawValue
        }
    }

    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date.now, forKey: "time")
        setPrimitiveValue(IntakeType.water.rawValue, forKey: "type")
        setPrimitiveValue(250, forKey: "ammount")
    }

    static func empty(context: NSManagedObjectContext = IntakesProvider.shared.viewContext) -> Intake {
        return Intake(context: context)
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

extension Intake {
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Intake] {
        var intakes = [Intake]()
        
        for _ in 0..<count {
            let intake = Intake(context: context)
            intake.ammount = 300
            intake.type = IntakeType.allCases.randomElement()!.rawValue
            intake.time = Date()
            intakes.append(intake)
        }
        
        return intakes
    }
    
    static func preview(context: NSManagedObjectContext = IntakesProvider.shared.viewContext) -> Intake {
        return makePreview(count: 1, in: context)[0]
    }
}
