//
//  HealthKitService.swift
//  Hydration
//
//  Created by Rafael Ribeiro on 25.07.23.
//

import Foundation
import HealthKit

final class HealthKitService {
    static let shared = HealthKitService()
    private(set) var store: HKHealthStore?

    private init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        }
    }

    func requestAuthorization() async throws {
        // Type of unit the app requests access to dietary water.
        let dietaryWater = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        
        guard let store = self.store else {
            throw HealthKitError.unavailable
        }

        do {
            try await store.requestAuthorization(toShare: [dietaryWater], read: [])
        } catch {
            throw HealthKitError.authorizationFailed(error.localizedDescription)
        }
    }

    @MainActor
    func saveData(_ intakes: [Intake]) async throws {
        let dietaryWater = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!

        if intakes.isEmpty {
            throw HealthKitError.noDataToSend
        }

        guard let store = self.store else {
            throw HealthKitError.unavailable
        }
        
        let authorizationStatus = store.authorizationStatus(for: dietaryWater)
        if authorizationStatus != .sharingAuthorized {
            throw HealthKitError.unauthorized
        }

        do {
            try await store.save(createHealthKitSamples(from: intakes, withType: dietaryWater))
        } catch {
            throw HealthKitError.failedToSave(error.localizedDescription)
        }
    }
}

extension HealthKitService {
    func createHealthKitSamples(from intakes: [Intake], withType type: HKQuantityType) -> [HKQuantitySample] {
        var samples: [HKQuantitySample] = []
        for intake in intakes {
            let sample = HKQuantitySample(
                type: type,
                quantity: HKQuantity(
                    unit: HKUnit.literUnit(with: .milli),
                    doubleValue: Double(intake.ammount)
                ),
                start: intake.time,
                end: intake.time
            )
            samples.append(sample)
        }
        return samples
    }
}
