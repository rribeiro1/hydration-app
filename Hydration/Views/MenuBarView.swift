//
//  MenuView.swift
//  hydrationfy
//
//  Created by Rafael Ribeiro on 10.07.23.
//

import SwiftUI

struct MenuBarView: View {
    var infoAction: () -> Void
    var settingsAction: () -> Void
    var newIntakeAction: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            
            Button(action: infoAction) {
                Image(systemName: "info.bubble")
                    .foregroundColor(Theme.text)
                    .scaleEffect(1.5)
            }

            CustomButton(
                text: "Add Intake",
                systemImage: "plus.app",
                action: newIntakeAction
            )

            Button(action: settingsAction) {
                Image(systemName: "gearshape")
                    .foregroundColor(Theme.text)
                    .scaleEffect(1.5)
            }
        }
        .padding(.horizontal, 40)
        .frame(height: 60)
    }
}

struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarView(
            infoAction: {},
            settingsAction: {},
            newIntakeAction: {}
        )
    }
}
