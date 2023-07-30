//
//  HealthKitError.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 30.07.23.
//

import Foundation

enum HealthKitError: Error, LocalizedError {
    case unavailable
    case unauthorized
    case authorizationFailed(String)
    case failedToSave(String)
    
    var errorDescription: String? {
        switch self {
        case .unavailable:
            return "Health app is not available in the user's device."
        case .unauthorized:
            return "The user has explicitly denied permission to share data with Health app."
        case .authorizationFailed(let string):
            return string
        case .failedToSave(let string):
            return string
        }
    }
}
