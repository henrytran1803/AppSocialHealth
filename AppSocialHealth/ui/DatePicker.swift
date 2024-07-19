//
//  DatePicker.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 18/7/24.
//

import SwiftUI

struct DatePickerValidationView: View {
    @Binding var selectedDate : Date
    @State private var isValidDate = true
    
    let minDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    let maxDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: minDate...maxDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            if !isValidDate {
                Text("Selected date is not valid. Please choose another date.")
                    .foregroundColor(.red)
            }
            
            Button(action: validateDate) {
                Text("Validate Date")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func validateDate() {
        if selectedDate < minDate || selectedDate > maxDate {
            isValidDate = false
        } else {
            isValidDate = true
        }
    }
}
