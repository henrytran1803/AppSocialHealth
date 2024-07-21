//
//  PhotoPicker.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import Foundation
import PhotosUI
import SwiftUI
struct PhotoPicker: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?

    @ObservedObject var model = CommentViewModel()
    var body: some View {
        VStack {
            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
                .onChange(of: avatarItem) { newItem in
                        Task {
                            // Retrieve selected photo from PhotosPicker
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                avatarData = data
                                avatarImage = Image(uiImage: UIImage(data: data)!)
                            }
                        }
                    }
            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            
            Button(action: {
                if let data = avatarData {
                       let comment = CreateComment(body: "hello", user_id: 6, post_id: 3, photo: data)
                       model.createComment(comment: comment) { success in
                           if success {
                               print("Comment created successfully")
                           } else {
                               print("Failed to create comment")
                           }
                       }
                   } else {
                       let comment = CreateCommentNonePhoto(body: "aaa", user_id: 6, post_id: 3)
                       model.createCommentNonePhoto(comment: comment) { success in
                           if success {
                               print("Comment created successfully")
                           } else {
                               print("Failed to create comment")
                           }
                       }
                   }
                
                   }) {
                       Text("Submit Comment")
                   }
        }
        .onChange(of: avatarItem) {
            Task {
                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                    avatarImage = loaded
                } else {
                    print("Failed")
                }
            }
        }
    }
}
