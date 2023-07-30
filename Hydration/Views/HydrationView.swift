//
//  ContentView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct HydrationView: View {
    @EnvironmentObject var vm: HydrationViewModel

    @State private var showInfo: Bool = false
    @State private var showSettings: Bool = false
    @State private var showCreateIntake: Bool = false

    var body: some View {
        NavigationStack {
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
                    ProgressBar(progress: vm.progress, goal: vm.goal, intakeAmmount: vm.intakesAmmount)
                        .frame(width: 200.0, height: 200.0)
                        .padding(40.0)
                }

                Spacer()
 
                ZStack {
                    if vm.intakes.isEmpty {
                        EmptyIntakesView()
                    } else {
                        List {
                            ForEach(vm.intakes) { intake in
                                IntakeRowView(intake: intake)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            vm.delete(intake)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
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
                        NavigationStack {
                            InfoView()
                        }
                    }

                    CustomButton(
                        text: "Add Intake",
                        systemImage: "plus.app"
                    ) {
                        haptic()
                        showCreateIntake.toggle()
                    }
                    .sheet(isPresented: $showCreateIntake) {
                        NavigationStack {
                            CreateIntakeView()
                        }
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
                        NavigationStack {
                            SettingsView()
                        }
                    }
                }
                .padding(.horizontal, 40)
                .frame(height: 60)
            }
            .padding()
            .background(Theme.background)
            .task {
                await vm.requestAccess()
                vm.fetchGoal()
                vm.fetchIntakes()
            }
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
            .environmentObject(HydrationViewModel())
    }
}
