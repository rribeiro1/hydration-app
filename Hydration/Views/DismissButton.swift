//
//  DismissButton.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 14.07.23.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "x.circle")
                .symbolVariant(.fill)
                .font(.system(size: 25))
                .foregroundColor(Theme.text)
                .opacity(0.2)
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
