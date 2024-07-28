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
                VStack(alignment:.center){
                    ScrollView {
                        VStack(spacing: 16) {
                            header
                            profileInfo
                            Divider()
                            HStack{
                                Spacer()
                                photoGrid(geometry: geometry)
                                Spacer()
                            }
                            
                        }
                    }
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
        HStack(spacing: 20) {
            profileImage
            
            VStack(alignment: .leading, spacing: 8) {
                nameAndEmail
                Divider()
                physicalStats
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private var profileImage: some View {
        Group {
            if let uiImage = UIImage(data: modeluser.user.photo?.image ?? Data()) {
                CircleImage(uiImage: uiImage)
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
        }
        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
    }

    private var nameAndEmail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(modeluser.user.firstname) \(modeluser.user.lastname)")
                .font(.title2)
                .fontWeight(.bold)
            Text(modeluser.user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var physicalStats: some View {
        VStack(alignment: .leading, spacing: 8) {
            statRow(title: "Height", value: modeluser.user.height, unit: "cm")
            statRow(title: "Weight", value: modeluser.user.weight, unit: "kg")
            statRow(title: "Body Fat", value: modeluser.user.bdf, unit: "%")
            statRow(title: "TDEE", value: modeluser.user.tdee, unit: "kcal")
            statRow(title: "Calorie", value: modeluser.user.calorie, unit: "kcal")
        }
    }

    private func statRow(title: String, value: Double, unit: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(value, specifier: "%.1f") \(unit)")
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
    private func photoGrid(geometry: GeometryProxy) -> some View {
        let gridItems = [GridItem(.fixed(geometry.size.width * 0.31), spacing: 3, alignment: .leading),
                         GridItem(.fixed(geometry.size.width * 0.31), spacing: 3, alignment: .leading),
                         GridItem(.fixed(geometry.size.width * 0.31), spacing: 3, alignment: .leading)]

        return LazyVGrid(columns: gridItems, spacing: 3) {
            ForEach(Array(modelpost.posts.enumerated()), id: \.element.id) { index, post in
                if let uiImage = UIImage(data: post.photos.first?.image ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: index == 4 ? geometry.size.width * 0.63 : geometry.size.width * 0.31,
                               height: index == 4 ? geometry.size.width * 0.63 : geometry.size.width * 0.31)
                        .clipped()
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedPost = post
                            isOpenPost = true
                        }
                        .shadow(radius: 5)
                        .frame(height: geometry.size.width * 0.32, alignment: .top)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: index == 4 ? geometry.size.width * 0.63 : geometry.size.width * 0.31,
                               height: index == 4 ? geometry.size.width * 0.63 : geometry.size.width * 0.31)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedPost = post
                            isOpenPost = true
                        }
                        .shadow(radius: 5)
                        .frame(height: geometry.size.width * 0.31, alignment: .top)
                }
                
                if index == 4 {
                    Color.clear
                }
                if index == 5 {
                    Group {
                        Color.clear
                        Color.clear
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
