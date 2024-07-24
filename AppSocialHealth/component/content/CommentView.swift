//
//  CommentView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import SwiftUI
import PhotosUI

struct CommentView: View {
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
    @State var isLike: Bool
    @Binding var isOpen : Bool
    @ObservedObject var likeModel = LikeModelView()
    @ObservedObject var modelComment = CommentViewModel()
    var body: some View {
        VStack {
            HStack{
                Button {
                    isOpen = false
                } label: {
                    Image(systemName: "arrow.left")
                }
                Spacer()
            }
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
                Button(action: { isShowingBottom = true }, label: {
                    Image(systemName: "ellipsis")
                })
            }
            .padding(.horizontal)

            if post.photos.isEmpty {
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
                Text("\(post.title)")
                    .bold()

                ExpandableText(text: post.body)
                    
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
                    Image(systemName: isLike ? "heart.fill" : "heart")
                        .foregroundColor(isLike ? Color.red : Color.black)
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
            HStack {
                TextFieldView(text: $bodyy,title :"nhập")
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Label {
                    } icon: {
                        Image(systemName: "photo") // Sử dụng biểu tượng hình ảnh
                            .resizable()
                            .frame(width: 30, height: 30) // Đặt kích thước cho biểu tượng
                    }
                }
                .onChange(of: avatarItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            avatarData = data
                            avatarImage = Image(uiImage: UIImage(data: data)!)
                        }
                    }
                }
                Button(action: {
                    if let data = avatarData {
                           let comment = CreateComment(body: bodyy, user_id: 6, post_id: post.id, photo: data)
                        modelComment.createComment(comment: comment) { success in
                               if success {
                                   print("Comment created successfully")
                               } else {
                                   print("Failed to create comment")
                               }
                           }
                       } else {
                           let comment = CreateCommentNonePhoto(body: bodyy, user_id: 6, post_id: post.id)
                           modelComment.createCommentNonePhoto(comment: comment) { success in
                               if success {
                                   print("Comment created successfully")
                               } else {
                                   print("Failed to create comment")
                               }
                           }
                       }
                    
                       }) {
                           Image(systemName: "paperplane")
                               .resizable()
                               .frame(width: 30, height: 30)
                       }
                
            }.foregroundColor(.black.opacity(0.3))
            
                
                avatarImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
            ScrollView{
                ForEach($modelComment.comments,id: \.id){ comment in
                    ItemCommentView(comment: comment)
                }
            }
                
              
        }.onAppear{
                modelComment.fetchAllComentByPostId(postId:  post.id){success in
                    if success {
                        
                    }else {
                        
                    }
                }
        }
    }
}

