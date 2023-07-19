//
//  SettingsView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI



struct SettingsView: View {
    @Binding var goal: Int

    @AppStorage(UserDefaultKeys.hapticsEnabled)
    private var isHapticsEnable: Bool = true

    @AppStorage(UserDefaultKeys.colorScheme)
    private var selectedTheme: AppTheme = .system
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("App"),
                    footer: Text("Haptic feedback will be automatically disabled if your device is low on battery.")
                ) {
                    Label {
                        Picker("Color Scheme", selection: $selectedTheme) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                Text(theme.rawValue.capitalized)
                                    .tag(theme)
                            }
                        }
                        .pickerStyle(.menu)
                    } icon: {
                        Image(systemName: "sun.max")
                            .symbolVariant(.fill)
                            .foregroundColor(Theme.text)
                    }
                    
                    Label {
                        Toggle("Haptic Feedback", isOn: $isHapticsEnable)
                    } icon: {
                        Image(systemName: "water.waves")
                            .foregroundColor(Theme.text)
                    }
                }
                
                Section(
                    header: Text("Goals")
                ) {
                    Label {
                        Picker("Set your goal", selection: $goal) {
                            ForEach(stride(from: 500, through: 4001, by: 500).map { $0 }, id: \.self) { goal in
                                Text("\(goal) mL")
                                    .foregroundColor(Theme.text)
                            }
                        }
                        .pickerStyle(.menu)
                    } icon: {
                        Image(systemName: "drop")
                            .symbolVariant(.fill)
                            .foregroundColor(Theme.text)
                    }
                }
                
                Section(
                    header: Text("Apple Health"),
                    footer: Text("Logging to Health deletes all intake listings from this app! Intake is logged and reset automatically at the start of each day.")
                ) {
                    Label {
                        Text("Log to Health")
                            .foregroundColor(Color.orange)
                    } icon: {
                        Image(systemName: "heart")
                            .symbolVariant(.fill)
                            .foregroundColor(Color.orange)
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Made with")
                Image(systemName: "heart")
                    .symbolVariant(.fill)
                    .foregroundColor(.red)
                Text("in Berlin")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(selectedTheme.color)
        .background(Theme.systemBackground)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(goal: .constant(3000))
        }
    }
}
