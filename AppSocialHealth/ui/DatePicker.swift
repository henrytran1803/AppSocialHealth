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
struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    @State private var formattedDateString = ""
@State var isSuccess = false
    @State var isFail = false
    var body: some View {
        VStack {
            DatePicker("Chọn ngày", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
            HStack {
                Button("Xong") {
                    formatDate()
                    ScheduleViewModel().CreateSchedule(schedule: ScheduleCreateFull(user_id: 0, time: formattedDateString, detail: [])) { success in
                        if success {
                            isSuccess = true
                        }else {
                            isFail = true
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Huỷ") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()
        }
        .padding()
        .alert("Thêm thành công", isPresented: $isSuccess) {
            Button("OK",role: .cancel){
            }
        }
        .alert("Thêm thất bại", isPresented: $isFail) {
            Button("OK",role: .cancel){
            }
        }
    }

    private func formatDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formattedDateString = formatter.string(from: selectedDate)
    }
}

