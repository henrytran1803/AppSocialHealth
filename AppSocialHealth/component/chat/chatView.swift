//
//  chatView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var convertionModel = ConvertionViewModel()
    @State var isOpen = false
    @State var isCreateNew = false
@State var isLoading = true
    @State var message = Convertion(id: 0, created_at: "", participants: [], users: [])
    var body: some View {
        GeometryReader{ geomtry in
        if isLoading {
            AnimatedPlaceHolder()
        }else {
            VStack {
                HStack{
                    Text("Trung tâm tin nhắn")
                    Menu("•••") {
                        Button("Tạo đoạn chat mới", action: {
                            isCreateNew = true
                        } )
                    }
                    
                }
                List {
                    ForEach(convertionModel.convertions, id: \.id) { convertion in
                        let currentUserID = UserDefaults.standard.integer(forKey: "user_id")
                        let otherUser = convertion.users.first { $0.id != currentUserID }
                        let user = otherUser ?? User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0)
                        
                        ItemConversationListView(user: user)
                            .onTapGesture {
                                isOpen = true
                                message = convertion
                            }
                    }
                }.refreshable {
                    convertionModel.convertions = []
                    isLoading = true
                    convertionModel.fetchAllConvertionByuser{success in
                        if success {
                            isLoading = false
                        }else {
                            print("fail")
                        }
                        
                    }
                }
                
            }
            .fullScreenCover(isPresented: $isCreateNew) {
                CreateNewConversationView(isOpen: $isCreateNew)
            }
            .onChange(of: isCreateNew){ newValue in
                if !newValue {
                    isLoading = true
                    convertionModel.convertions = []
                    convertionModel.fetchAllConvertionByuser { success in
                        if success {
                            isLoading = false
                        }else {
                            print("fail")
                        }
                    }
                }
            }

            .fullScreenCover(isPresented: $isOpen){
                let currentUserID = UserDefaults.standard.integer(forKey: "user_id")
                ConversationView(convertion: $message, isOpen : $isOpen, user: message.users.first(where: { $0.id != currentUserID }))
            }.background(Color.white)
        }
        }
        .onAppear {
            isLoading = true
            convertionModel.fetchAllConvertionByuser { success in
                if success {
                    isLoading = false
                }else {
                    print("fail")
                }
            }
        }
        
    }
}


