//
//  SettingView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 30/7/24.
//
import SwiftUI

struct SettingView: View {
    @State private var isNotificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    @State var isLoading = true
    @Binding var isOpen: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Cài Đặt")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Divider()
                    .padding(.vertical, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Thông Báo")
                        .font(.headline)
                    
                    Toggle(isOn: $isNotificationsEnabled) {
                        Text(isNotificationsEnabled ? "Thông báo được bật" : "Thông báo bị tắt")
                            .fontWeight(.medium)
                            .foregroundColor(isNotificationsEnabled ? .green : .red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .onChange(of: isNotificationsEnabled) { value in
                        UserDefaults.standard.set(value, forKey: "notificationsEnabled")
                        if value {
                            AppSocialHealthApp.requestNotificationAuthorization()
                        } else {
                            AppSocialHealthApp.disableNotifications()
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
            .navigationBarItems(trailing: Button(action: {
                isOpen = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}
