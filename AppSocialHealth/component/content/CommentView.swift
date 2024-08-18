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
    @Binding var isOpen: Bool
    @ObservedObject var likeModel = LikeModelView()
    @ObservedObject var modelComment = CommentViewModel()
    @State var isReload = false
    var body: some View {
        VStack {
            headerView
            
            postContentView
            
            actionButtonsView
            
            postStatisticsView
            
            commentInputView
            
            if let avatarImage = avatarImage {
                avatarImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.bottom)
            }
            
            commentsListView
        }
        .onAppear {
            modelComment.fetchAllComentByPostId(postId: post.id) { success in
                if success {
                    // Handle success if needed
                } else {
                    // Handle failure if needed
                }
            }
        }
        .id(isReload)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private var headerView: some View {
        HStack {
            Button {
                isOpen = false
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.bottom, 8)
    }
    
    private var postContentView: some View {
        VStack(alignment: .leading) {
            HStack {
                if let uiImage = UIImage(data: post.user.photo?.image ?? Data()) {
                    MiniCircleimage(uiImage: uiImage)
                        .frame(width: 40, height: 40)
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 40, height: 40)
                }
                
                Text("\(post.user.firstname) \(post.user.lastname)")
                    .bold()
                    .font(.system(size: 16))
                
                Spacer()
                
                Button(action: { isShowingBottom = true }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                })
            }
            
            if !post.photos.isEmpty {
                TabView {
                    ForEach(post.photos, id: \.id) { photo in
                        if let uiImage = UIImage(data: photo.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(8)
                        } else {
                            Color.gray
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 250)
                .cornerRadius(8)
                .padding(.top, 8)
            }
            
            VStack(alignment: .leading) {
                Text(post.title)
                    .bold()
                    .font(.title3)
                
                ExpandableText(text: post.body)
                    .padding(.top, 4)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    private var actionButtonsView: some View {
        HStack {
            Button(action: toggleLike, label: {
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
        .padding(.top, 8)
    }
    
    private var postStatisticsView: some View {
        HStack {
            Text("\(post.count_likes) lượt thích")
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("\(post.count_comments) lượt bình luận")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
    
    private var commentInputView: some View {
        HStack {
            TextFieldView(text: $bodyy, title: "Nhập bình luận...")
            
            PhotosPicker(selection: $avatarItem, matching: .images) {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .onChange(of: avatarItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        avatarData = data
                        avatarImage = Image(uiImage: UIImage(data: data)!)
                    }
                }
            }
            
            Button(action: postComment) {
                Image(systemName: "paperplane")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.leading, 8)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var commentsListView: some View {
        ScrollView {
            ForEach(Array($modelComment.comments.enumerated()), id: \.offset) { index, comment in
                ItemCommentView(comment: comment)
            }
        }
        .padding(.top, 8)
    }
    
    private func toggleLike() {
        if likeModel.isLike {
            likeModel.DelteLike(post_id: post.id) { success in
                if success {
                    likeModel.isLike = false
                } else {
                    // Handle failure
                }
            }
        } else {
            likeModel.CreateLikes(post_id: post.id) { success in
                if success {
                    likeModel.isLike = true
                } else {
                    // Handle failure
                }
            }
        }
    }
    
    private func postComment() {
        if let data = avatarData {
            let comment = CreateComment(body: bodyy, user_id: 6, post_id: post.id, photo: data)
            modelComment.createComment(comment: comment) { success in
                if success {
                    isReload.toggle()
                    bodyy = ""
                } else {
                    print("Failed to create comment")
                }
            }
        } else {
            let comment = CreateCommentNonePhoto(body: bodyy, user_id: 6, post_id: post.id)
            modelComment.createCommentNonePhoto(comment: comment) { success in
                if success {
                    isReload.toggle()
                    bodyy = ""
                    print("Comment created successfully")
                } else {
                    print("Failed to create comment")
                }
            }
        }
    }
}
