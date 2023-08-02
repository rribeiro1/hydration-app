//
//  AddIntakeView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct AddIntakeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: EditIntakeViewModel

    private let items = stride(from: 100, through: 2001, by: 50).map { $0 }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("New Intake")
                .font(.title)
                .bold()

            HStack {
                Picker("Select a quantity", selection: $vm.intake.type) {
                    ForEach(["Water", "Coffee", "Juice", "Other"], id: \.self) { item in
                        Text(item)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Image(systemName: "drop.fill")
                    .foregroundColor(vm.intake.intakeType.color)
                    .font(.system(size: 40))
            }


            Picker("Select an ammount", selection: $vm.intake.ammount) {
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
                    do {
                        try vm.save()
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 60)
        }
        .padding()
    }
}

struct AddIntakeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            let preview = IntakesProvider.shared
            AddIntakeView(vm: .init(provider: preview))
                .environment(\.managedObjectContext, preview.viewContext)
        }
    }
}
