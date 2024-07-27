//
//  AppSocialHealthApp.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 3/7/24.
//
import SwiftUI
import TipKit
@main
struct AppSocialHealthApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var webSocketManager = WebSocketManager.shared
    @State var id: Int = 0
    init() {
        do {
           try Tips.configure()
       } catch {
           print("Failed to configure TipKit: \(error)")
       }
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
             if granted {
                 print("Notification permission granted.")
             } else {
                 print("Notification permission denied.")
             }
         }
     }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(webSocketManager)
                .onAppear {
                    id = UserDefaults.standard.integer(forKey: "user_id")
                    webSocketManager.connect(userID: "\(id)")
                }
                .onDisappear {
                    webSocketManager.disconnect()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var shared: AppDelegate?
      
      override init() {
          super.init()
          AppDelegate.shared = self
      }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        WebSocketManager.shared.checkForMessages { newMessages in
            if newMessages.count > 0 {
                self.showNotifications(for: newMessages)
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
    }

    func showNotifications(for messages: [String]) {
        for message in messages {
            let content = UNMutableNotificationContent()
            content.title = "Tin nhắn mới" // Vietnamese for "New Message"
            content.body = message
            content.sound = .default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
