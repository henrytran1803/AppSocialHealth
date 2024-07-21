//
//  UpdatePostView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//
import SwiftUI
import PhotosUI

struct UpdatePostView: View {
    @ObservedObject var model: PostViewModel = PostViewModel()
    @Binding var post: Post
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [IdentifiableImage] = []
    @State private var avatarData: [Data] = []
    @State var updatePost: UpdatePost = UpdatePost(id: 0, title: "", body: "", user_id: 0)
    
    var body: some View {
        VStack {
            TextFieldView(text: $updatePost.title, title: "Nhập tiêu đề")
            TextFieldView(text: $updatePost.body, title: "Nhập nội dung")
            PhotosPicker("Select photos", selection: $selectedItems, matching: .images, photoLibrary: .shared())
                .onChange(of: selectedItems) { newItems in
                    Task {
                        avatarData = []
                        selectedImages = []
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                avatarData.append(data)
                                selectedImages.append( IdentifiableImage(image: Image(uiImage: uiImage))  )
                            }
                        }
                    }
                }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedImages) { image in
                        image.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            HStack {
                ForEach(post.photos, id: \.id) { photo in
                    VStack {
                        if let uiImage = UIImage(data: photo.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                        } else {
                            Color.gray
                                .frame(width: 100, height: 100)
                        }
                        Button(action: {
                            ImageViewModel().deletePhoto(id: photo.id) { success in
                                if success {
                                    print("Photo deleted")
                                } else {
                                    print("Failed to delete photo")
                                }
                            }
                        }) {
                            Text("Remove")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            Button(action: {
                model.updatePost(post: updatePost) { success in
                    if success {
                        for data in avatarData {
                            let photoBase = PhotoBase(photo_type: "1", image: data, url: "", post_id: "\(updatePost.id)")
                            ImageViewModel().createPhoto(photo: photoBase) { success in
                                if success {
                                    print("Photo created")
                                } else {
                                    print("Failed to create photo")
                                }
                            }
                        }
                    } else {
                        print("Failed to update post")
                    }
                }
            }) {
                Text("Update")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            updatePost.id = post.id
            updatePost.title = post.title
            updatePost.body = post.body
            updatePost.user_id = post.user_id
        }
    }
}
struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: Image
}
