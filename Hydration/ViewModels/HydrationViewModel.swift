//
//  HomeViewModel.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 13.07.23.
//

import SwiftUI

class HydrationViewModel: ObservableObject {
    @Published private(set) var intakes: [Intake] = []
    @Published private(set) var intakesQuantity: Int = 0
    @Published var progress: Float = 0.0

    @AppStorage(UserDefaultKeys.intakeGoal)
    var intakeGoal: Int = 500

    func add(_ intake: Intake) {
        intakes.append(intake)
        refreshProgres()
    }

    func delete(at index: IndexSet) {
        intakes.remove(atOffsets: index)
        refreshProgres()
    }

    func refreshProgres() {
        intakesQuantity = intakes.reduce(0, { $0 + $1.quantity })
        progress = Float(intakesQuantity) / Float(intakeGoal)
    }
}
