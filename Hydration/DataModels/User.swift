//
//  User.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 23.07.23.
//

import Foundation
import CoreData

final class User: NSManagedObject, Identifiable {
    @NSManaged var goal: Int

    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(3000, forKey: "goal")
    }
}
