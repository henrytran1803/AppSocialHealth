//
//  UserUpdateView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import SwiftUI
import PhotosUI
struct UserUpdateView: View {
    @Binding var isOpen: Bool
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var imageViewModel = ImageViewModel()
    @State private var userUpdate = UserUpdate(id: 0, email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, status: 0)
    @State private var showImagePicker = false
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            Button("Quay về") {
                isOpen = false
            }
            .padding()
            
            Form {
                TextField("Email", text: $userUpdate.email)
                TextField("First Name", text: $userUpdate.firstname)
                TextField("Last Name", text: $userUpdate.lastname)
                TextField("Height", value: $userUpdate.height, formatter: NumberFormatter())
                TextField("Weight", value: $userUpdate.weight, formatter: NumberFormatter())
                TextField("Body Fat", value: $userUpdate.bdf, formatter: NumberFormatter())
                TextField("TDEE", value: $userUpdate.tdee, formatter: NumberFormatter())
                TextField("Calorie", value: $userUpdate.calorie, formatter: NumberFormatter())
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
                Button("Chọn ảnh") {
                    showImagePicker = true
                }
                .padding()
                
                Button("Cập nhật") {
                    userViewModel.updateUser(userInput: userUpdate) { success in
                        if success {
                            if let selectedImage = image {
                                let imageData = selectedImage.jpegData(compressionQuality: 0.8)
                                let photo = PhotoBase( photo_type: "1", image: imageData, url: "", user_id: "\(userUpdate.id)")
                                imageViewModel.deletePhoto(id: userUpdate.id) { _ in
                                    imageViewModel.createPhoto(photo: photo) { _ in }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                userViewModel.fetchUser { success in
                    if success {
                        userUpdate = UserUpdate(
                            id: userViewModel.user.id,
                            email: userViewModel.user.email,
                            firstname: userViewModel.user.firstname,
                            lastname: userViewModel.user.lastname,
                            role: userViewModel.user.role,
                            height: userViewModel.user.height,
                            weight: userViewModel.user.weight,
                            bdf: userViewModel.user.bdf,
                            tdee: userViewModel.user.tdee,
                            calorie: userViewModel.user.calorie,
                            status: userViewModel.user.status
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}
