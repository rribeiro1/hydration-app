//
//  IntakeRowView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import Foundation
import SwiftUI

struct IntakeRowView: View {
    var intake: Intake

    var body: some View {
        HStack {
            Text("\(intake.ammount) mL")
                .bold()
            Spacer()
            Text(intake.type.rawValue.capitalized)
            Image(systemName: "drop.fill")
                .foregroundColor(intake.type.color)
            Text(DateFormatterManager.shared.time(date: intake.time))
        }
        .padding(.vertical, 10)
    }
}

struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: Intake(ammount: 100, type: .water, time: Date()))
    }
}
