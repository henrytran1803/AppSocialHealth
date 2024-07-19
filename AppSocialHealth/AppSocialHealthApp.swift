//
//  AppSocialHealthApp.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 3/7/24.
//

import SwiftUI

@main
struct AppSocialHealthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Call your WebSocketManager to check for new messages
        WebSocketManager.shared.checkForMessages { newMessages in
            if newMessages.count > 0 {
                // Process new messages and show notifications if needed
                self.showNotifications(for: newMessages)
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
    }

    private func showNotifications(for messages: [String]) {
        for message in messages {
            let content = UNMutableNotificationContent()
            content.title = "New Message"
            content.body = message
            content.sound = .default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
