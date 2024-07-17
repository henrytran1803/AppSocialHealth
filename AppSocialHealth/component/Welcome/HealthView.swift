//
//  HealthView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import SwiftUI
import HealthKit

struct HealthView: View {
    @State private var stepCount: Double = 0
    let healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            Text("Step Count: \(Int(stepCount))")
                .font(.title)
                .padding()

            Button("Fetch Step Count") {
                healthKitManager.requestAuthorization { (success, error) in
                    if success {
                        healthKitManager.fetchStepCount { (count, error) in
                            if let count = count {
                                DispatchQueue.main.async {
                                    self.stepCount = count
                                }
                            } else if let error = error {
                                print("Error fetching step count: \(error.localizedDescription)")
                            }
                        }
                    } else if let error = error {
                        print("Authorization failed: \(error.localizedDescription)")
                    }
                }
            }
            .padding()
        }
    }
}
