//
//  Health.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import Foundation
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "com.yourapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit không khả dụng trên thiết bị này"]))
            return
        }

        let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }

    func fetchStepCount(completion: @escaping (Double?, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.yourapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit không khả dụng trên thiết bị này"]))
            return
        }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: nil, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil, error)
                return
            }

            let stepCount = sum.doubleValue(for: HKUnit.count())
            completion(stepCount, nil)
        }

        healthStore.execute(query)
    }
}
