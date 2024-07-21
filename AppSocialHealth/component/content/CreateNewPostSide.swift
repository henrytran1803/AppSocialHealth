//
//  CreateNewPostSide.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import SwiftUI
import PhotosUI
struct CreateNewPostSide: View {
    @ObservedObject var model : PostViewModel
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?
    
    @State var createPost =  CreatePost(title: "", body: "", user_id: 0)
    var body: some View {
        VStack{

            TextFieldView(text: $createPost.title, title: "Nhập tiêu đề")
            TextFieldView(text: $createPost.body, title: "Nhập nội dung")
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
                    createPost.photos = data
                       model.createPost(post: createPost) { success in
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
        } .onChange(of: avatarItem) {
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



//#Preview {
//    CreateNewPostSide()
//}
