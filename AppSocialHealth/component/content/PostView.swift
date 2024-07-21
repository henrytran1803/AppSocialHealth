//
//  PostView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 20/7/24.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI
struct PostView: View {
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var avatarData: Data?
    @Binding var post: Post
    @State private var isShowingBottom = false
    @State private var isShowingBottomShare = false
    @State private var isMark = false
    @State var isBubble = false
    @State private var isExpanded = false
    @State var bodyy = ""
    @ObservedObject var likeModel = LikeModelView()
    @ObservedObject var modelComment = CommentViewModel()
    @State var isEdit = false
    @State var alertDelete = false
    @Binding var isReload : Bool
    var body: some View {
        VStack {
            HStack {
                if let uiImage = UIImage(data: post.user.photo?.image ?? Data()) {
                    MiniCircleimage(uiImage: uiImage)
                        .frame(width: 30, height: 30)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 30, height: 30)
                }
                Text("\(post.user.firstname) \(post.user.lastname)")
                    .bold()
                    .font(.system(size: 15))

                Spacer()
                Menu("•••") {
                    Button("Edit", action: {
                        
                        var id =  UserDefaults.standard.integer(forKey: "user_id")
                        if id == post.user_id {
                            isEdit = true
                        }
                        
                        
                        
                    } )
                    Button("Delete", action: {
                        var id =  UserDefaults.standard.integer(forKey: "user_id")
                        if id == post.user_id {
                            alertDelete = true
                        }
                        
                        
                        
                    })
                }
            }
            .padding(.horizontal)

            if post.photos.isEmpty {
                // Handle case where there are no photos
            } else {
                TabView {
                    ForEach(post.photos, id: \.id) { photo in
                        if let uiImage = UIImage(data: photo.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.gray
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 250)
            }

            VStack (alignment: .leading){
                HStack{
                    Text("\(post.title)")
                        .bold()
                   Spacer()
                }
               
                HStack{
                    ExpandableText(text: post.body)
                    Spacer()
                }
                    
            }.padding(.horizontal)

            HStack {
                Button(action: {
                    if likeModel.isLike {
                        likeModel.DelteLike(post_id: post.id){success in
                            if success {
                                likeModel.isLike = false
                            }else {
                                
                            }
                        }
                    }else {
                        likeModel.CreateLikes(post_id: post.id){success in
                            if success {
                                likeModel.isLike = true
                            }else {
                                
                            }
                        }
                    }
                    
                }, label: {
                    Image(systemName: likeModel.isLike ? "heart.fill" : "heart")
                        .foregroundColor(likeModel.isLike ? Color.red : Color.black)
                })
                Button(action: { isBubble.toggle() }, label: {
                    Image(systemName: isBubble ? "bubble.fill" : "bubble")
                        .foregroundColor(.black)
                })
                Spacer()
                Button(action: { isShowingBottomShare = true }, label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(.black)
                })
            }
            .padding(.horizontal)
            .font(.system(size: 25))

            HStack {
                Text("\(post.count_likes) lượt thích")
                    .bold()
                    .font(.system(size: 10))
                Spacer()
                Text("\(post.count_comments) lượt bình luận")
                    .bold()
                    .font(.system(size: 10))
            }
            .padding(.leading)
            .alert("Bạn có chắc muốn xoá", isPresented: $alertDelete) {
                        Button("OK", role: .destructive) {
                            PostViewModel().deletePostById(id: post.id){
                                success in
                                if success {
                                    print("oke")
                                }else {
                                    print("fail")
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    }
        }.onAppear{
            likeModel.CheckIsLike(post_id: post.id){success in
                if success {
                    
                }else {
                    
                }
            }
        }
        .sheet(isPresented: $isEdit){
            UpdatePostView( post: $post)
                .onDisappear{
                    isReload = true
                }
        }
        .sheet(isPresented: $isBubble){
            CommentView(post: $post, isLike: likeModel.isLike)
                .onDisappear{
                    isReload = true
                }
        }
     
    }
}
struct ExpandableText: View {
    var text: String
    @State private var isExpanded: Bool = false
    @State private var textHeight: CGFloat = .zero
    @State private var needsShowMoreButton: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundColor(.black.opacity(0.7))
                .lineLimit(isExpanded ? nil : 2)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                let size = geometry.size
                                let lineHeight = UIFont.systemFont(ofSize: 14).lineHeight
                                let maxHeight = lineHeight * 2
                                if size.height > maxHeight {
                                    needsShowMoreButton = true
                                }
                            }
                    }
                )
            
            if needsShowMoreButton {
                Button(action: { isExpanded.toggle() }) {
                    Text(isExpanded ? "See Less" : "See More")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                        .padding(.top, 5)
                }
            }
        }
    }
}
