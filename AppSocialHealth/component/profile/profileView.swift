//
//  profileView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isLogin: Bool
    @ObservedObject var modeluser = UserViewModel()
    @ObservedObject var modelpost = PostViewModel()
    @State var isLoading = false
    @State var isEdit = false
    @State var isOpenPost = false
    @State var selectedPost :Post = Post(id: 0, title: "", body: "", user_id: 0, count_likes: 0, count_comments: 0, photos: [], user: User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0))
    var body: some View {
        GeometryReader{ geomrtry in
            if isLoading {
                LoadingView()
            }else {
                ScrollView {
                    HStack{
                        Spacer()
                        Text("Trang cá nhân")
                        Spacer()
                        Menu {
                            sectionElementButton(title: "Setting", icon: "arrowshape.turn.up.left", action: {
                                
                            })
                            sectionElementButton(title: "Edit profile", icon: "arrowshape.turn.up.left", action: {
                                isEdit = true
                            })
                            sectionElementButton(title: "Logout", icon: "arrowshape.turn.up.left", action: {
                                isLogin = false
                                LoginViewModel().logout()
                            })
                        } label: {
                            Circle()
                                .fill(.gray.opacity(0.15))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "gear")
                                        .font(.system(size: 13.0, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding()
                                }
                        }
                    }
                    HStack{
                        if let uiImage = UIImage(data: modeluser.user.photo?.image ?? Data()) {
                            CircleImage(uiImage: uiImage)
                                .frame(width: 70, height: 70)
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 70, height: 70)
                        }
                        Spacer()
                        
                    }
                    HStack{
                        VStack(alignment: .leading) {
                            Text("\(modeluser.user.firstname) \(modeluser.user.lastname)")
                                .font(.headline)
                            Text("Email: \(modeluser.user.email)")
                                .font(.subheadline)
                            Text("Height: \(modeluser.user.height, specifier: "%.2f") cm")
                                .font(.subheadline)
                            Text("Weight: \(modeluser.user.weight, specifier: "%.2f") kg")
                                .font(.subheadline)
                            Text("Body Fat: \(modeluser.user.bdf, specifier: "%.2f") %")
                                .font(.subheadline)
                            Text("TDEE: \(modeluser.user.tdee, specifier: "%.2f") kcal")
                                .font(.subheadline)
                            Text("Calorie: \(modeluser.user.calorie, specifier: "%.2f") kcal")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    Divider()
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(modelpost.posts, id: \.id) { post in
                            if let uiImage = UIImage(data: post.photos.first?.image ?? Data()) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geomrtry.size.width * 0.32, height:  geomrtry.size.width * 0.32)
                                    .clipped()
                                    .onTapGesture {
                                        selectedPost = post
                                        isOpenPost = true
                                    }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(width:  geomrtry.size.width * 0.32, height:  geomrtry.size.width * 0.32)
                                    .onTapGesture {
                                        selectedPost = post
                                        isOpenPost = true
                                    }
                            }
                        }
                    }
                }
        }
        }.onAppear{
            isLoading = false
            modeluser.fetchUser{
                success in
                if success {
                    modelpost.fetchAllPostById{
                        success in
                        if success {
                           isLoading = false
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isOpenPost){
            CommentView(post: $selectedPost, isLike: false, isOpen: $isOpenPost)
        }
        .fullScreenCover(isPresented: $isEdit){
            UserUpdateView(isOpen: $isEdit)
        }
    }
    
    @ViewBuilder
    func sectionElementButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(title)
                    .font(.system(size: 14.0, weight: .medium, design: .default))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(.red)
                    .font(.system(size: 14.0, weight: .semibold, design: .default))
            }
        }
    }
}
