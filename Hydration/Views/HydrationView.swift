//
//  ContentView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct HydrationView: View {
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
                Text("\(vm.intakeAmmount) mL")
                Text("/")
                Text("\(vm.goal) mL")
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

            HStack(alignment: .center, spacing: 40) {
                Button(action: {
                    haptic()
                    showInfo.toggle()
                }) {
                    Image(systemName: "info.bubble")
                        .foregroundColor(Theme.text)
                        .scaleEffect(1.5)
                }
                .sheet(isPresented: $showInfo) {
                    InfoView()
                }

                CustomButton(
                    text: "Add Intake",
                    systemImage: "plus.app"
                ) {
                    haptic()
                    showNewIntake.toggle()
                }
                .sheet(isPresented: $showNewIntake) {
                    AddIntakeView { vm.add($0) }
                    .presentationDetents([.medium])
                }

                Button(action: {
                    haptic()
                    showSettings.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(Theme.text)
                        .scaleEffect(1.5)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(goal: $vm.goal)
                }
            }
            .padding(.horizontal, 40)
            .frame(height: 60)
        }
        .padding(.vertical)
        .background(Theme.background)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
    }
}
