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

    var color: ColorScheme? {
        switch self {
            case .system: return nil
            case .light: return ColorScheme.light
            case .dark: return ColorScheme.dark
        }
    }
}
