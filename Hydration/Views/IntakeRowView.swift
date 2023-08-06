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
    var selectedIntake: (Intake) -> Void

    var body: some View {
        
        /* MARK: Verify whether the intake object has a valid state.
         * When an object is deleted from the context, it gets turned into a fault.
         * If we try to access any of the properties of that fault, CoreData will
         * try to fire the fault and reload the data from the persistent store.
         * However, because the object has been deleted, this will result in an error.
         */
        if !intake.isFault {
            HStack {
                Text("\(intake.amount) mL")
                    .bold()

                Spacer()

                Image(systemName: intake.processed ? "heart" : "arrow.clockwise.heart")
                    .symbolVariant(.fill)
                    .foregroundColor(intake.processed ? .red : .gray)
                    .overlay(alignment: .bottomTrailing) {
                        if intake.processed {
                            Image(systemName: "checkmark")
                                .symbolVariant(.circle)
                                .symbolVariant(.fill)
                                .foregroundColor(.green)
                                .font(.system(size: 12.0))
                                .offset(x: 3, y: 3)
                        }
                    }
                    .onTapGesture {
                        selectedIntake(intake)
                    }

                HStack {
                    Text(intake.type)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Image(systemName: "drop")
                        .symbolVariant(.fill)
                        .foregroundColor(intake.intakeType.color)
                }
                .frame(width: 80, alignment: .trailing)

                Text(DateHelper.formatTime(date: intake.time))
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.vertical, 10)
        } else {
            EmptyView()
        }
    }
}

struct IntakeRowView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeRowView(intake: .preview()) { _ in }
    }
}
