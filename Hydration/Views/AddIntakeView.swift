//
//  AddIntakeView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct AddIntakeView: View {
    @Environment(\.dismiss) private var dismiss

    @State var selectedIntakeType: IntakeType = .water
    @State var selectedAmmount: Int = 250

    private let items = stride(from: 100, through: 2001, by: 50).map { $0 }
    private let onSelectAmmount: (Intake) -> Void

    public init(onSelectAmmount: @escaping (Intake) -> Void) {
        self.onSelectAmmount = onSelectAmmount
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("New Intake")
                .font(.title)
                .bold()

            Picker("Select a quantity", selection: $selectedIntakeType) {
                ForEach(IntakeType.allCases, id: \.self) { item in
                    Text(item.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)

            Image(systemName: "drop.fill")
                .foregroundColor(selectedIntakeType.color)
                .font(.system(size: 40))

            Picker("Select an ammount", selection: $selectedAmmount) {
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
                    dismiss()
                    onSelectAmmount(Intake(ammount: selectedAmmount, type: selectedIntakeType))
                }
            )
            .frame(height: 60)
            .padding(.horizontal, 60)
        }
        .padding()
    }
}

struct AddIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        AddIntakeView { quantity in print(quantity) }
    }
}
