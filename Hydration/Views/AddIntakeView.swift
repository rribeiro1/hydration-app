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
    @State var selectedQuantity: Int = 250

    private let items = stride(from: 100, through: 2001, by: 50).map { $0 }
    private let onSelectQuantity: (Intake) -> Void

    public init(onSelectQuantity: @escaping (Intake) -> Void) {
        self.onSelectQuantity = onSelectQuantity
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

            Picker("Select a quantity", selection: $selectedQuantity) {
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
                    onSelectQuantity(Intake(quantity: selectedQuantity, type: selectedIntakeType))
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
