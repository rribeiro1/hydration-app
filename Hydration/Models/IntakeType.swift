//
//  IntakeType.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import Foundation
import SwiftUI

enum IntakeType : String, CaseIterable {
    case water
    case coffee
    case juice
    case other
    
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
