//
//  Intake.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import Foundation

struct Intake: Identifiable {
    var id: UUID = UUID()
    var ammount: Int
    var type: IntakeType
    var time: Date = Date()
}
