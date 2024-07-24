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
        HStack {
            if let imageData = user.photo?.image, let uiImage = UIImage(data: imageData) {
                  Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
              } else {
                  Circle()
                      .frame(width: 40, height: 40, alignment: .center)
                      .cornerRadius(20)
              }
            Text("\(user.firstname) \(user.lastname)")
                .foregroundColor(.black)
            Spacer()
        }
        .overlay{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black.opacity(0.3),lineWidth: 3)
                .foregroundColor(.clear)
        }
    }
}
