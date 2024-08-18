//
//  ItemCommentView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import SwiftUI

struct ItemCommentView: View {
    @Binding var comment : Comment
    var body: some View {
        VStack{
            HStack {
                if let uiImage = UIImage(data: comment.user.photo?.image ?? Data()) {
                    MiniCircleimage(uiImage: uiImage)
                        .frame(width: 30, height: 30)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 30, height: 30)
                }
                Text("\(comment.user.firstname) \(comment.user.lastname)")
                    .bold()
                    .font(.system(size: 15))
                Text("\(comment.body)")
                    .foregroundColor(.black.opacity(0.3))
                    .font(.system(size: 15))
                Spacer()
            }
            if let uiImage = UIImage(data: comment.photos?.image ?? Data()) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40)
            } else {
            }
            Divider()
        }
    }
}

