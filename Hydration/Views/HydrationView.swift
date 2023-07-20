//
//  ContentView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct HydrationView: View {
    @FetchRequest(fetchRequest: Intake.all()) private var intakes
    @State private var intakeToEdit: Intake?
    @State private var showInfo: Bool = false
    @State private var showSettings: Bool = false

    @StateObject private var vm = HydrationViewModel()

    var provider = IntakesProvider.shared
    
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
                    ProgressBar(progress: $vm.progress)
                        .frame(width: 200.0, height: 200.0)
                        .padding(40.0)
                }
                
                HStack {
                    Text("\(vm.intakeAmmount) mL")
                    Text("/")
                    Text("\(vm.goal) mL")
                }
                
                Spacer()
 
                ZStack {
                    if intakes.isEmpty {
                        EmptyIntakesView()
                    } else {
                        List {
                            ForEach(intakes) { intake in
                                IntakeRowView(intake: intake)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            do {
                                                try provider.delete(intake, in: provider.viewContext)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                        Button {
                                            intakeToEdit = intake
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.orange)
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
                        intakeToEdit = .empty(context: provider.newContext)
                    }
                    .sheet(item: $intakeToEdit, onDismiss: { intakeToEdit = nil }, content: { intake in
                        NavigationStack {
                            AddIntakeView(vm: .init(provider: provider, intake: intake))
                        }
                        .presentationDetents([.medium])
                    })

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
                            SettingsView(goal: $vm.goal)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .frame(height: 60)
            }
            .padding()
            .background(Theme.background)
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        let preview = IntakesProvider.shared
        HydrationView(provider: preview)
            .environment(\.managedObjectContext, preview.viewContext)
            .previewDisplayName("Intakes with Data")
            .onAppear {
                Intake.makePreview(count: 10, in: preview.viewContext)
            }
        
        let emptyPreview = IntakesProvider.shared
        HydrationView(provider: emptyPreview)
            .environment(\.managedObjectContext, emptyPreview.viewContext)
            .previewDisplayName("Intakes with no Data")
    }
}
