//
//  Websco.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//
import Foundation
import UserNotifications

class WebSocketViewModel: ObservableObject {
    private var webSocketManager: WebSocketManager
    @Published var receivedMessage: String = ""

    init() {
        self.webSocketManager = WebSocketManager.shared
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedMessage(_:)), name: .didReceiveMessage, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didReceiveMessage, object: nil)
    }

    func connect() {
        let userID = UserDefaults.standard.string(forKey: "user_id") ?? ""
        webSocketManager.connect(userID: userID)
    }

    func disconnect() {
        webSocketManager.disconnect()
    }

    func sendMessage(to userID: String, message: String) {
        webSocketManager.sendMessage(to: userID, message: message)
    }

    @objc private func handleReceivedMessage(_ notification: Notification) {
        if let message = notification.userInfo?["message"] as? String {
            DispatchQueue.main.async {
                self.receivedMessage = message
                self.sendLocalNotification(message: message)
            }
        }
    }

    private func sendLocalNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Message"
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
