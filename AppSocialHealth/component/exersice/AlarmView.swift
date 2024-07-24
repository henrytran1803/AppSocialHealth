//
//  AlarmView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import SwiftUI

struct AlarmView: View {
    @State private var selectedDate = Date()
    @State private var showAlert = false

    var body: some View {
        VStack {
            DatePicker("Chọn Ngày & Giờ", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button(action: scheduleNotification) {
                Text("Đặt Báo Thức")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Báo Thức Đã Đặt"), message: Text("Báo thức của bạn đã được đặt vào \(selectedDate.formatted())"), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Báo Thức"
        content.body = "Đến giờ rồi!"
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Lỗi khi đặt thông báo: \(error)")
            } else {
                DispatchQueue.main.async {
                    showAlert = true
                }
            }
        }
    }
}
