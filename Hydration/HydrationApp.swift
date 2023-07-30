//
//  HydrationApp.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

@main
struct HydrationApp: App {
    @AppStorage(UserDefaultKeys.colorScheme)
    private var selectedTheme: AppTheme = .system
    
    @StateObject var hydrationModelView = HydrationViewModel()

    var body: some Scene {
        WindowGroup {
            HydrationView()
                .environmentObject(hydrationModelView)
                .preferredColorScheme(selectedTheme.color)
        }
    }
}
