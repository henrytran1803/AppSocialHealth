//
//  AlarmView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//
import SwiftUI
import UserNotifications

struct AlarmView: View {
    @State private var selectedDate = Date()
    @State private var showAlert = false

    var body: some View {
        VStack {
            Text("Chọn Ngày & Giờ")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 20)

            DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxWidth: .infinity, minHeight: 300)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding()

            Button(action: scheduleNotification) {
                Text("Đặt Báo Thức")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Báo Thức Đã Đặt"),
                    message: Text("Báo thức của bạn đã được đặt vào \(selectedDate.formatted(date: .abbreviated, time: .shortened))"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
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

