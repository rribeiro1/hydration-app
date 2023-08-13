//
//  ContentView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI
import ConfettiSwiftUI

struct HydrationView: View {
    @EnvironmentObject var vm: HydrationViewModel

    /// Control progress
    @AppStorage(UserDefaultKeys.goal) private var goal: Int = 3000
    @State private var progress: Float = 0.0
    @State private var intakesAmount: Int = 0
    @State private var dailyGoalCounter: Int = 0

    /// Control alerts
    @State private var showInfo: Bool = false
    @State private var showSettings: Bool = false
    @State private var showCreateIntake: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text(DateHelper.formatFullDate(date: Date()))
                        .font(.title)
                        .bold()
                        .padding(.bottom, 2)
                    Text("Here is your fluid intake")
                        .italic()
                }
                
                ZStack {
                    ProgressBar(progress: progress, goal: goal, intakeAmount: intakesAmount)
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
                                IntakeRowView(intake: intake) { _ in
                                    Task { await vm.logIntake(intake: intake) }
                                }
                            }
                            .onDelete(perform: vm.delete)
                        }
                        .listStyle(.plain)
                    }
                }
                .confettiCannon(
                    counter: $dailyGoalCounter,
                    num: 2,
                    confettis: [.sfSymbol(symbolName: "drop.fill")],
                    colors: [
                        IntakeType.coffee.color,
                        IntakeType.juice.color,
                        IntakeType.water.color,
                        IntakeType.other.color
                    ],
                    confettiSize: 20,
                    radius: 360,
                    repetitions: 75,
                    repetitionInterval: 0.1
                )

                Spacer()

                HStack(alignment: .center, spacing: 40) {
                    Button(action: {
                        haptic()
                        showInfo.toggle()
                    }) {
                        Image(systemName: "info.bubble")
                            .foregroundColor(ColorTheme.text)
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
                            .foregroundColor(ColorTheme.text)
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
            .task {
                vm.fetchIntakes()
            }
            .onReceive(vm.$intakes, perform: { _ in
                updateProgress()
            })
            .onChange(of: goal, perform: { _ in
                updateProgress()
            })
            .alert(isPresented: $vm.showAlert) {
                Alert(
                    title: Text(vm.alertTitle),
                    message: Text(vm.alertMessage)
                )
            }
            .padding()
            .loading(vm.isLoading)
        }
    }
}

extension HydrationView {
    private func updateProgress() {
        intakesAmount = vm.intakes.reduce(0, { $0 + $1.amount })
        progress = Float(intakesAmount) / Float(goal)
        if progress >= 1.0 {
            dailyGoalCounter += 1
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
            .environmentObject(HydrationViewModel())
    }
}
