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
            Image(systemName: "x.circle.fill")
                .font(.title)
                .bold()
                .foregroundColor(Theme.text)
                .opacity(0.3)
        }
    }
}

#Preview {
    DismissButton()
}
