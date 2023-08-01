//
//  SettingsView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: HydrationViewModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage(UserDefaultKeys.hapticsEnabled)
    private var isHapticsEnable: Bool = true

    @AppStorage(UserDefaultKeys.colorScheme)
    private var selectedTheme: AppTheme = .system

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
                        .accentColor(Theme.text)
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
                        Picker("Set your goal", selection: $vm.goal) {
                            ForEach(stride(from: 500, through: 4001, by: 500).map { $0 }, id: \.self) { goal in
                                Text("\(goal) mL")
                                    .foregroundColor(Theme.text)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Theme.text)
                        .onChange(of: vm.goal) { newGoal in
                            vm.saveGoal(goal: newGoal)
                        }
                    } icon: {
                        Image(systemName: "drop")
                            .symbolVariant(.fill)
                            .foregroundColor(Theme.text)
                    }
                }
                
                Section(
                    header: Text("Apple Health"),
                    footer: Text("Log water consumption manually in Health app, you will see a heart icon displayed when the icon is synced with Health app! Intakes are logged and reset automatically at the start of each day.")
                ) {
                    Label {
                        Button("Log to Health") {
                            Task(priority: .userInitiated) {
                                await vm.logIntakes()
                                haptic()
                            }
                        }
                    } icon: {
                        Image(systemName: "heart")
                            .symbolVariant(.fill)
                    }
                    .foregroundColor(Color.orange)
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
                Button("Close") {
                    haptic()
                    dismiss()
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(selectedTheme.color)
        .background(Theme.systemBackground)
        .alert(isPresented: $vm.showAlert) {
            Alert(
                title: Text(vm.alertTitle),
                message: Text(vm.alertMessage)
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(HydrationViewModel())
        }
    }
}
