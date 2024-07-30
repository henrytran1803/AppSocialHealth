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
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileImageSection
                    userInfoSection
                    physicalStatsSection
                    updateButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Cập nhật thông tin", displayMode: .inline)
            .navigationBarItems(leading: dismissButton)
        }
        .onAppear(perform: loadUserData)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            if let image = image ?? UIImage(data: userViewModel.user.photo?.image ?? Data()) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }
            
            Button(action: { showImagePicker = true }) {
                Text("Thay đổi ảnh")
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
        }
    }
    
    private var userInfoSection: some View {
        VStack(spacing: 15) {
            customTextField(title: "Email", text: $userUpdate.email)
            customTextField(title: "Họ", text: $userUpdate.firstname)
            customTextField(title: "Tên", text: $userUpdate.lastname)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var physicalStatsSection: some View {
        VStack(spacing: 15) {
            customNumberField(title: "Chiều cao (cm)", value: $userUpdate.height)
            customNumberField(title: "Cân nặng (kg)", value: $userUpdate.weight)
            customNumberField(title: "Tỷ lệ mỡ cơ thể (%)", value: $userUpdate.bdf)
            customNumberField(title: "TDEE (kcal)", value: $userUpdate.tdee)
            customNumberField(title: "Calorie (kcal)", value: $userUpdate.calorie)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var updateButton: some View {
        Button(action: updateUserInfo) {
            Text("Cập nhật")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
    
    private var dismissButton: some View {
        Button(action: { isOpen = false }) {
            Image(systemName: "xmark")
                .foregroundColor(.blue)
        }
    }
    
    private func customTextField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.secondary)
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private func customNumberField(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundColor(.secondary)
            TextField(title, value: value, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private func loadUserData() {
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
    
    private func updateUserInfo() {
        userViewModel.updateUser(userInput: userUpdate) { success in
            if success {
                if let selectedImage = image {
                    let imageData = selectedImage.jpegData(compressionQuality: 0.8)
                    let photo = PhotoBase(photo_type: "1", image: imageData, url: "", user_id: "\(userUpdate.id)")
                    imageViewModel.deletePhoto(id: userUpdate.id) { _ in
                        imageViewModel.createPhoto(photo: photo) { _ in }
                    }
                }
                isOpen = false
            }
        }
    }
}
