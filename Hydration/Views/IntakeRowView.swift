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
        
        /* MARK: Verify whether the intake object has a valid state.
         * When an object is deleted from the context, it gets turned into a fault.
         * If we try to access any of the properties of that fault, CoreData will
         * try to fire the fault and reload the data from the persistent store.
         * However, because the object has been deleted, this will result in an error.
         */
        if !intake.isFault {
            HStack {
                Text("\(intake.ammount) mL")
                    .bold()
                Spacer()
                Image(systemName: "heart")
                    .symbolVariant(.fill)
                    .foregroundColor(intake.processed ? .red : .gray)
                    .overlay {
                        if intake.processed {
                            Image(systemName: "checkmark.circle.fill")
                                .offset(x: 8, y: 5)
                                .foregroundColor(.green)
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.horizontal, 5)
                Text(intake.type)
                Image(systemName: "drop.fill")
                    .foregroundColor(intake.intakeType.color)
                Text(DateHelper.formatTime(date: intake.time))
            }
            .padding(.vertical, 10)
        } else {
            EmptyView()
        }
    }
}

struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: .preview())
    }
}
