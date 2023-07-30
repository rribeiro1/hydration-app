//
//  IntakeRowView.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 12.07.23.
//

import Foundation
import SwiftUI

struct IntakeRowView: View {
    @ObservedObject var intake: Intake

    var body: some View {
        HStack {
            Text("\(intake.ammount) mL")
                .bold()
            Spacer()
            Image(systemName: "heart")
                .symbolVariant(.fill)
                .foregroundColor(intake.processed ? .red : .gray)
                .opacity(0.7)
            Text(intake.type)
            Image(systemName: "drop.fill")
                .foregroundColor(intake.intakeType.color)
            Text(DateFormatterManager.shared.time(date: intake.time))
        }
        .padding(.vertical, 10)
    }
}

struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: .preview())
    }
}
