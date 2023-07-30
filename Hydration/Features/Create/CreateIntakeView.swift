//
//  AddIntakeView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct CreateIntakeView: View {
    @EnvironmentObject var vm: HydrationViewModel
    @Environment(\.dismiss) private var dismiss

    @State var ammount: Int = 250
    @State var type: IntakeType = .water

    private let items = stride(from: 100, through: 2001, by: 50).map { $0 }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Picker("Select a quantity", selection: $type) {
                    ForEach(IntakeType.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Image(systemName: "drop.fill")
                    .foregroundColor(type.color)
                    .font(.system(size: 40))
            }

            Picker("Select an ammount", selection: $ammount) {
                ForEach(items, id: \.self) { item in
                    Text("\(item) mL")
                }
            }
            .pickerStyle(.inline)

            CustomButton(
                text: "Save",
                systemImage: "square.and.arrow.down",
                action: {
                    haptic()
                    vm.createIntake(ammount: ammount, type: type)
                    dismiss()
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Intake")
            .navigationBarTitleDisplayMode(.inline)
            .frame(height: 60)
            .padding(.horizontal, 60)
        }
        .padding()
    }
}

struct CreateIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateIntakeView()
                .environmentObject(HydrationViewModel())
        }
    }
}
