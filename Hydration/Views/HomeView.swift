//
//  ContentView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct HomeView: View {
    @State private var showInfo: Bool = false
    @State private var showSettings: Bool = false
    @State private var showNewIntake: Bool = false

    @StateObject private var vm = HydrationViewModel()

    var body: some View {
        VStack {
            VStack {
                Text(DateFormatterManager.shared.fullDate(date: Date()))
                    .font(.title)
                    .bold()
                    .padding(.bottom, 2)
                Text("Here is your fluid intake")
                    .italic()
            }
            
            ZStack {
                ProgressBar(progress: $vm.progress)
                    .frame(width: 200.0, height: 200.0)
                    .padding(40.0)
            }
            
            HStack {
                Text("\(vm.intakesQuantity) mL")
                Text("/")
                Text("\(vm.intakeGoal) mL")
            }
            
            if !vm.intakes.isEmpty {
                List {
                    ForEach(vm.intakes) { intake in
                        IntakeRowView(intake: intake)
                    }
                    .onDelete(perform: vm.delete)
                }
            }

            Spacer()

            MenuBarView(
                infoAction: {
                    haptic()
                    showInfo.toggle()
                },
                settingsAction: {
                    haptic()
                    showSettings.toggle()
                },
                newIntakeAction: {
                    haptic()
                    showNewIntake.toggle()
                }
            )
        }
        .padding(.vertical)
        .sheet(isPresented: $showInfo) {
            InfoView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showNewIntake) {
            AddIntakeView { vm.add($0) }
            .presentationDetents([.medium])
        }
        .background(Theme.background)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
