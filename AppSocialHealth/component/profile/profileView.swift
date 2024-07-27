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
    @State var isLoading = true
    @State var isEdit = false
    @State var isOpenPost = false
    @State var selectedPost :Post = Post(id: 0, title: "", body: "", user_id: 0, count_likes: 0, count_comments: 0, photos: [], user: User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0))
    
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        header
                        profileInfo
                        Divider()
                        photoGrid(geometry: geometry)
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
                
                .fullScreenCover(isPresented: $isOpenPost) {
                    CommentView(post: $selectedPost, isLike: false, isOpen: $isOpenPost)
                }
                .fullScreenCover(isPresented: $isEdit) {
                    UserUpdateView(isOpen: $isEdit)
                }
            }
        }.onAppear {
            isLoading = true
            modeluser.fetchUser { success in
                if success {
                    modelpost.fetchAllPostById { success in
                        
                        if success {
                            isLoading = false
                        } else {
                            print("err")
                        }
                    }
                }else {
                    print("err")
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Spacer()
            Text("Trang cá nhân")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Menu {
                sectionElementButton(title: "Setting", icon: "gear", action: {
                    
                })
                sectionElementButton(title: "Edit profile", icon: "pencil", action: {
                    isEdit = true
                })
                sectionElementButton(title: "Logout", icon: "arrow.right.square", action: {
                    isLogin = false
                    LoginViewModel().logout()
                })
            } label: {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 30, height: 30)
                    .overlay {
                        Image(systemName: "gear")
                            .font(.system(size: 13.0, weight: .semibold))
                            .foregroundColor(.black)
                            .padding()
                    }
            }
        }
        .padding([.leading, .trailing, .top])
    }
    
    private var profileInfo: some View {
        HStack {
            if let uiImage = UIImage(data: modeluser.user.photo?.image ?? Data()) {
                CircleImage(uiImage: uiImage)
                    .frame(width: 70, height: 70)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 70, height: 70)
            }
            VStack(alignment: .leading, spacing: 4) {
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
            .padding(.leading, 8)
            Spacer()
        }
    }
    
    private func photoGrid(geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(modelpost.posts, id: \.id) { post in
                if let uiImage = UIImage(data: post.photos.first?.image ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 0.32, height: geometry.size.width * 0.32)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedPost = post
                            isOpenPost = true
                        }
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: geometry.size.width * 0.32, height: geometry.size.width * 0.32)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedPost = post
                            isOpenPost = true
                        }
                        .shadow(radius: 5)
                }
            }.padding()
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
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.system(size: 14.0, weight: .semibold, design: .default))
            }
        }
    }
}
