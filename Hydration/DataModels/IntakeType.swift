//
//  IntakeType.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import Foundation
import SwiftUI

enum IntakeType : String, CaseIterable {
    case water = "Water"
    case coffee = "Coffee"
    case juice = "Juice"
    case other = "Other"

    var color: Color {
        switch self {
        case .water:
            return .blue
        case .coffee:
            return .brown
        case .juice:
            return .orange
        case .other:
            return .gray
        }
    }
}
