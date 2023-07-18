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
    
    var body: some Scene {
        WindowGroup {
            HydrationView()
                .preferredColorScheme(selectedTheme.color)
                .environment(\.managedObjectContext, IntakesProvider.shared.viewContext)
        }
    }
}
