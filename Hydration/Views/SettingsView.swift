//
//  SettingsView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage(UserDefaultKeys.hapticsEnabled)
    private var isHapticsEnable: Bool = true

    @AppStorage(UserDefaultKeys.intakeGoal)
    private var intakeGoal: Int = 500

    @EnvironmentObject
    private var vm: HydrationViewModel

    private var goals = stride(from: 500, through: 4001, by: 500).map { $0 }

    var body: some View {
        VStack {
            ZStack {
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Spacer()
                    DismissButton()
                        .padding(.trailing, 20)
                }
            }
            .padding(.top, 20)
            
            Form {
                Section(
                    header: Text("App"),
                    footer: Text("Haptic feedback will be automatically disabled if your device is low on battery.")
                ) {
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
                        Picker("Set your goal", selection: $intakeGoal) {
                            ForEach(goals, id: \.self) { goal in
                                Text("\(goal) mL")
                                    .foregroundColor(Theme.text)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(
                            of: intakeGoal,
                            perform: { _ in vm.refreshProgres()}
                        )
                    } icon: {
                        Image(systemName: "drop.fill")
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
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.orange)
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Made with")
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("in Berlin")
            }
            .font(.caption)
            .foregroundColor(.gray)

        }
            .background(Theme.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
