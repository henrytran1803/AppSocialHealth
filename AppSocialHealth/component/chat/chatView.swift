//
//  chatView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct chatView: View {
    @StateObject private var viewModel = WebSocketViewModel()

    var body: some View {
        VStack {
            Button("Connect") {
                viewModel.connect()
            }
            Button("Disconnect") {
                viewModel.disconnect()
            }
            Button("Send Message") {
                viewModel.sendMessage(message: "Hello WebSocket")
            }
            Text("Received Message: \(viewModel.receivedMessage)")
                .padding()
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
            }
        }
    }
}

#Preview {
    chatView()
}
