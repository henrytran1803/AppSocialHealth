//
//  CreateNewPostSide.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

//import SwiftUI
//import PhotosUI
//struct CreateNewPostSide: View {
//    @ObservedObject var model : PostViewModel
//    @State private var avatarItem: PhotosPickerItem?
//    @State private var avatarImage: Image?
//    @State private var avatarData: Data?
//    
//    @State var createPost =  CreatePost(title: "", body: "", user_id: 0)
//    var body: some View {
//        VStack{
//
//            TextFieldView(text: $createPost.title, title: "Nhập tiêu đề")
//            TextFieldView(text: $createPost.body, title: "Nhập nội dung")
//            PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
//                .onChange(of: avatarItem) { newItem in
//                        Task {
//                            // Retrieve selected photo from PhotosPicker
//                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                                avatarData = data
//                                avatarImage = Image(uiImage: UIImage(data: data)!)
//                            }
//                        }
//                    }
//            avatarImage?
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300)
//            
//            Button(action: {
//                if let data = avatarData {
//                    createPost.photos = data
//                       model.createPost(post: createPost) { success in
//                           if success {
//                               print("Comment created successfully")
//                           } else {
//                               print("Failed to create comment")
//                           }
//                       }
//                   }
//                   }) {
//                       Text("Submit Comment")
//                   }
//        } .onChange(of: avatarItem) {
//            Task {
//                if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
//                    avatarImage = loaded
//                } else {
//                    print("Failed")
//                }
//            }
//        }
//        
//    }
//}
import SwiftUI
import PhotosUI

struct CreateNewPostSide: View {
    @ObservedObject var model: PostViewModel
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var title = ""
    @State private var bodyy = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $bodyy)
                        .frame(height: 150)
                }
                
                Section(header: Text("Add Photo")) {
                    if let image = avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    PhotosPicker(selection: $avatarItem, matching: .images) {
                        Label(avatarImage == nil ? "Select Photo" : "Change Photo", systemImage: "photo")
                    }
                }
                
                Section {
                    Button(action: submitPost) {
                        Text("Create Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(title.isEmpty || bodyy.isEmpty)
                }
            }
            .navigationTitle("Create New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: avatarItem) { _ in
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        avatarImage = uiImage
                    }
                }
            }
        }
    }
    
    private func submitPost() {
        var createPost = CreatePost(title: title, body: bodyy, user_id: 0) // Thay thế 0 bằng user_id thực tế
        if let imageData = avatarImage?.jpegData(compressionQuality: 0.8) {
            createPost.photos = imageData
        }
        
        model.createPost(post: createPost) { success in
            if success {
                print("Post created successfully")
                dismiss()
            } else {
                print("Failed to create post")
            }
        }
    }
}
