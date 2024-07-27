//
//  MessageView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import SwiftUI

struct MessageView : View {
    @Binding var user: User?
    @State var currentMessage: Message
    @State var user_current = 0
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !(currentMessage.sender_id == user_current) {
                if let imageData = user?.photo?.image, let uiImage = UIImage(data: imageData) {
                      Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                  } else {
                      Circle()
                          .frame(width: 40, height: 40, alignment: .center)
                          .cornerRadius(20)
                  }
                ContentMessageView(contentMessage: currentMessage.content,
                                   isCurrentUser: (currentMessage.sender_id == user_current))
                Spacer()
            } else {
                Spacer()
                ContentMessageView(contentMessage: currentMessage.content,
                                   isCurrentUser: (currentMessage.sender_id == user_current))
            }
           
        }.onAppear{
            user_current = UserDefaults.standard.integer(forKey: "user_id")
        }
    }
    
}


struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}
