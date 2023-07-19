//
//  HomeViewModel.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 13.07.23.
//

import SwiftUI

class HydrationViewModel: ObservableObject {
    @Published var progress: Float = 0.0
    @Published private(set) var intakeAmmount: Int = 0
    @Published var goal: Int = 3000 {
        didSet {
            updateProgress()
        }
    }
    @Published private(set) var intakes: [Intake] = [] {
        didSet {
            updateProgress()
        }
    }

    func updateProgress() {
        intakeAmmount = intakes.reduce(0, { $0 + $1.ammount })
        progress = Float(intakeAmmount) / Float(goal)
    }
}
