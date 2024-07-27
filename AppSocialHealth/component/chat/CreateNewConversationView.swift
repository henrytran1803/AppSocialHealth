//
//  CreateNewConversationView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import SwiftUI

struct CreateNewConversationView: View {
    @ObservedObject var userModel = UserViewModel()
    @Binding var isOpen :Bool
    @State var searchText = ""
    @State var isLoading = false
    @State var isAlert = false
    @State var isAlertSuccess = false
    @State var isAlertFail = false

    @State var userSelected = User(email: "", firstname: "", lastname: "", role: 0, height: 0, weight: 0, bdf: 0, tdee: 0, calorie: 0, id: 0, status: 0)
    var body: some View {
        VStack{
            HStack{
                Button(action: {isOpen = false}, label: {Text("back")})
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black.opacity(0.2))
                    TextField("Search", text: $searchText)
                    
                }.padding([.leading, .trailing])
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.black.opacity(0.2),lineWidth: 2)
                    }
                
               
            }.padding([.leading, .trailing])
            List(filteredUsers, id: \.id) { user in
                      HStack {
                          if let photoData = user.photo?.image, let uiImage = UIImage(data: photoData) {
                              Image(uiImage: uiImage)
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 50, height: 50)
                                  .clipShape(Circle())
                          } else {
                              Circle()
                                  .fill(Color.gray)
                                  .frame(width: 50, height: 50)
                          }
                          VStack(alignment: .leading) {
                              Text("\(user.firstname) \(user.lastname)")
                                  .font(.headline)
                              Text(user.email)
                                  .font(.subheadline)
                                  .foregroundColor(.secondary)
                          }
                          Spacer()
                      }
                      .padding()
                      .background(Color.white)
                      .cornerRadius(10)
                      .shadow(radius: 5)
                      .onTapGesture {
                          userSelected = user
                          isAlert = true
                      }
                  }
                  .listStyle(PlainListStyle())
                  .padding()
                .alert("Bạn có muốn tạo đoạn hội thoại mới không", isPresented: $isAlert) {
                    Button("OK", role: .destructive) {
                        let id = UserDefaults.standard.integer(forKey: "user_id")
                        let createConversation = CreateConversation(participants: [id ,userSelected.id])
                        ConvertionViewModel().createConversation(createConversation:createConversation ){ success in
                            if success {
                                isAlertSuccess = true
                            }else {
                                isAlertFail = true
                            }
                            
                        }
                        
                    }
                            Button("Calcel", role: .cancel) { }
                        }
                .alert("Tạo thành công", isPresented: $isAlertSuccess) {
                    
                            Button("Calcel", role: .cancel) { }
                        }
                .alert("Tạo thất bại", isPresented: $isAlertFail) {
                    
                            Button("Calcel", role: .cancel) { }
                        }
        }.onAppear{
            userModel.fetchAllUser{ success in
                if success {
                    isLoading = false
                }else {
                    
                }
            }
        }
    }
    
    
    private var filteredUsers: [User] {
        if searchText.isEmpty {
            return userModel.users
        } else {
            return userModel.users.filter {
                ($0.firstname.lowercased().contains(searchText.lowercased()) ||
                 $0.lastname.lowercased().contains(searchText.lowercased())
                
                )
            }
        }
    }
    
}
