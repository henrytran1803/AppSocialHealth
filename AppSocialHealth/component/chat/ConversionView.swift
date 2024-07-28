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
    @State var user: User?
    @State private var scrollTo: Int?
    @State private var isLoading = true
    @Environment(\.colorScheme) var colorScheme
    
    private var currentUserID: Int {
        UserDefaults.standard.integer(forKey: "user_id")
    }
    
    private var firstUserEmail: String {
        convertion.users.first { $0.id != currentUserID }.map { "\($0.firstname) \($0.lastname)" } ?? "Unknown User"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                if isLoading {
                    AnimatedPlaceHolder()
                } else {
                    VStack(spacing: 0) {
                        headerView
                        messagesScrollView(geometry: geometry)
                        messageInputView
                    }
                }
            }
        }
        .onAppear(perform: loadMessages)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { isOpen = false }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            }
            
            Text(firstUserEmail)
                .font(.headline)
                .padding(.leading)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color(UIColor.systemBackground).opacity(0.8))
        .shadow(radius: 1)
    }
    
    private func messagesScrollView(geometry: GeometryProxy) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(messageModel.message.messages, id: \.id) { msg in
                    MessageView(user: $user, currentMessage: msg)
                        .frame(width: geometry.size.width)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollTo)
    }
    
    private var messageInputView: some View {
        HStack {
            TextField("Type a message...", text: $typingMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minHeight: 40)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.8))
    }
    
    private func loadMessages() {
        messageModel.convertion = convertion
        messageModel.fetchAllMessageConvertionByuser { success in
            if success {
                scrollTo = messageModel.message.messages.last?.id
                isLoading = false
            }
        }
    }
    
    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        
        let message = SendMessage(conversation_id: convertion.id, sender_id: currentUserID, content: typingMessage)
        messageModel.sendMessage(message: message) { success in
            if success {
                if let user = convertion.users.first(where: { $0.id != currentUserID }) {
                    webSocketViewModel.sendMessage(to: "\(user.id)", message: typingMessage)
                    typingMessage = ""
                }
                updateMessages()
            } else {
                print("Failed to send message")
            }
        }
    }
    
    private func updateMessages() {
        messageModel.fetchAllMessageConvertionByuser { success in
            if success {
                print("Messages updated")
                scrollTo = messageModel.message.messages.last?.id
            } else {
                print("Failed to update messages")
            }
        }
    }
}
