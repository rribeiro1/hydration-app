//
//  HapticsManager.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 11.07.23.
//

import Foundation
import UIKit
import CoreHaptics

fileprivate final class HapticsManager {
    static let shared = HapticsManager()
    
    private let feedback = UIImpactFeedbackGenerator(style: .light)
    
    private init() {}
    
    func trigger() {
        feedback.impactOccurred()
    }
}

func haptic() {
    if UserDefaults.standard.bool(forKey: UserDefaultKeys.hapticsEnabled) {
        HapticsManager.shared.trigger()
    }
}
