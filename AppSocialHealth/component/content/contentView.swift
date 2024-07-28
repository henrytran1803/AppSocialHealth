//
//  contentView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct contentView: View {
    @ObservedObject var modelPost = PostViewModel()
    @State var isNew = false
    @State var isLoading = true
    @State var isReload = false
    @State private var showingHeader = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                if isLoading {
                    AnimatedPlaceHolder()
                }else {
                    ScrollView{
                        Button(action: {
                            isNew = true
                        }, label: {
                            HStack {
                                Text("Tạo bài viết mới")
                                    .bold()
                            }
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .frame(maxWidth: geometry.size.width * 0.6,maxHeight: 50)
                        }) .buttonStyle(.borderedProminent)
                            .tint(.black)
                        
                        ForEach($modelPost.posts, id: \.id){post in
                            PostView(post: post, isReload: $isReload)
                            Divider()
                        }
                        .onChange(of: isReload) { newValue in
                              if newValue {
                                  modelPost.posts = []
                                  isLoading = true
                                  modelPost.fetchAllPost { success in
                                      if success {
                                          isLoading = false
                                          isReload = false
                                      } else {
                                          print("fail")
                                      }
                                  }
                              }
                          }
                    }.refreshable {
                        modelPost.posts = []
                        isLoading = true
                        modelPost.fetchAllPost{success in
                            if success {
                                isLoading = false
                            }else {
                                print("fail")
                            }
                            
                        }
                    }
                    .sheet(isPresented: $isNew){
                        CreateNewPostSide(model: modelPost)
                            .onDisappear{
                                modelPost.posts = []
                                isLoading = true
                                modelPost.fetchAllPost{success in
                                    
                                    if success {
                                        isLoading = false
                                    }else {
                                        print("fail")
                                    }
                                    
                                }

                            }
                    }
                }
            }.onAppear{
                isLoading = true
                modelPost.fetchAllPost{success in
                   
                    if success {
                        isLoading = false
                    }else {
                        print("fail")
                    }
                    
                }
            }
        }
    }
}
