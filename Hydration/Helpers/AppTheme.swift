//
//  AppTheme.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 16.07.23.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case system
    case dark
    case light

    var description: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var color: ColorScheme? {
        switch self {
            case .system: return nil
            case .light: return ColorScheme.light
            case .dark: return ColorScheme.dark
        }
    }
}
