//
//  ItemConversationListView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import Foundation
import SwiftUI


struct ItemConversationListView: View {
    @State var user: User
    
    var body: some View {
        HStack(spacing: 15) {
            if let imageData = user.photo?.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
            }
            
            VStack(alignment: .leading) {
                Text("\(user.firstname) \(user.lastname)")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("Last message preview...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
