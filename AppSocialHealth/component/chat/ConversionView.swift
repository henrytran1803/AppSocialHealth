//
//  ConversionView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//
import SwiftUI

struct ConversationView: View {
    @StateObject private var webSocketViewModel = WebSocketViewModel()
    @Binding var convertion: Convertion
    @Binding var isOpen: Bool
    @State private var typingMessage = ""
    @ObservedObject var messageModel: MessageViewModel = MessageViewModel()
    @State private var scrollViewProxy: ScrollViewProxy?
    @State var user : User?
    private var currentUserID: Int {
        return UserDefaults.standard.integer(forKey: "user_id")
    }

    var firstUserEmail: String {
        if let user = convertion.users.first(where: { $0.id != currentUserID }) {
            return "\(user.firstname) \(user.lastname)"
        }
        return "Unknown User"
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button {
                        isOpen = false
                    } label: {
                        Text("Back")
                    }
                    Text("\(firstUserEmail)")
                }

                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack {
                            ForEach(messageModel.message.messages, id: \.id) { msg in
                                MessageView(currentMessage: msg)
                                    .frame(width: geometry.size.width)
                            }
                        }
                        .onAppear {
                            scrollViewProxy = proxy
                            scrollToBottom(proxy: proxy)
                        }
                        .onChange(of: messageModel.message.messages.count) { _ in
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
                HStack {
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }
                .frame(minHeight: CGFloat(50))
                .padding()
            }
            .onAppear {
                messageModel.convertion = convertion
                messageModel.fetchAllMessageConvertionByuser { success in
                    if success {
                        print("ok")
                        scrollToBottom(proxy: scrollViewProxy)
                    } else {
                        print("fail")
                    }
                }
            }
        }
        .background(Color.white)
    }

    private func sendMessage() {
        let message = SendMessage(conversation_id: convertion.id, sender_id: currentUserID, content: typingMessage)
        messageModel.sendMessage(message: message) { success in
            if success {
                if let user = convertion.users.first(where: { $0.id != currentUserID }) {
                    webSocketViewModel.sendMessage(to: "\(user.id)", message: typingMessage)
                    typingMessage = ""
                }
                messageModel.fetchAllMessageConvertionByuser { success in
                    if success {
                        print("Messages updated")
                        scrollToBottom(proxy: scrollViewProxy)
                    } else {
                        print("Failed to update messages")
                    }
                }
            } else {
                print("Failed to send message")
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy?) {
        guard let proxy = proxy else { return }
        withAnimation {
            proxy.scrollTo(messageModel.message.messages.last?.id, anchor: .bottom)
        }
    }
}
