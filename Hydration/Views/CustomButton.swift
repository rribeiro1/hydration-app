//
//  CustomButton.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import SwiftUI

struct CustomButton: View {
    var text: String
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Theme.primary)

                HStack {
                    Text(text)
                        .foregroundColor(.white)
                    
                    Image(systemName: systemImage)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(text: "Add Intake", systemImage: "plus.app") {}
    }
}
