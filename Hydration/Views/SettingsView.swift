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
    private var isHapticsEnable: Bool = false

    @AppStorage(UserDefaultKeys.colorScheme)
    private var selectedTheme: AppTheme = .system

    @AppStorage(UserDefaultKeys.activeIcon)
    private var activeIcon: String = IconType.original.rawValue

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
                        NavigationLink {
                            ChangeIconView()
                        } label: {
                            HStack {
                                Text("App Icon")
                                Spacer()
                                Text(activeIcon)
                                    .foregroundColor(.gray)
                            }
                        }
                    } icon: {
                        Image(systemName: "app")
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
                    footer: Text("You can always record your water intake directly in Health app from here! When you see a gray heart icon next to an intake entry, it means the entry was not synced with the Health app yet.")
                ) {
                    Label {
                        HStack {
                            Button("Log to Health") {
                                Task(priority: .userInitiated) {
                                    await vm.logIntakes()
                                    haptic()
                                }
                            }
                            .disabled(vm.isLoading)

                            if vm.isLoading {
                                ProgressView()
                                    .padding(.horizontal, 10)
                            }
                        }
                    } icon: {
                        Image(systemName: "heart")
                            .symbolVariant(.fill)
                    }
                    .foregroundColor(vm.isLoading ? Color.gray : Color.orange)
                }
            }
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
