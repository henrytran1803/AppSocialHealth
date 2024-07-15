//
//  registerView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct registerView: View, SecuredTextFieldParentProtocol {
    @Binding var login: Bool
    @Binding var isForgot : Bool
    @Binding var isRegister: Bool
    @State var hideKeyboard: (() -> Void)?
    @State private var showingAlertFail = false
    @State private var showingAlertSuccess = false

    @ObservedObject var modelRegister = RegisterViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                        VStack(alignment: .leading){
                            Text("WELCOME!")
                                .font(.title)
                                .bold()
                            
                            Text("Please login or signup to continue app")
                                .foregroundColor(.black.opacity(0.5))
                        }.padding(.bottom, 50)
                    VStack(alignment: .center, spacing: 20) {
                        
                        
                        
                        TextFieldView(text: $modelRegister.register.email,title :"Enter Email")
                        TextFieldView(text: $modelRegister.register.firstName,title :"Enter Firstname")
                        TextFieldView(text: $modelRegister.register.lastName,title :"Enter Lastname")
//                            .frame(maxWidth: geometry.size.width * 0.9)
                        SecuredTextFieldView(text:  $modelRegister.register.password, parent: self,title: "Enter Password")
//                            .frame(maxWidth: geometry.size.width * 0.9)
                        
                        
                       Button(action: {
                            performHideKeyboard()
                            modelRegister.register{success in
                                if success {
                                   
                                    showingAlertSuccess = true
                                }else {
                                    showingAlertFail = true
                                }
                                print(modelRegister.errorMessage)
                            }
                        }, label: {
                            HStack {
                                Text("ĐĂNG KÝ")
                                    .bold()
                            }
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .frame(maxWidth: geometry.size.width * 0.6,maxHeight: 50)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .alert("password", isPresented: $showingAlertFail) {
                            Button("OK", role: .cancel) { }
                        }
                        .alert("password", isPresented: $showingAlertSuccess) {
                            Button("OK", role: .cancel) { }
                            Button("Back to login", role: .destructive){ 
                                login = true
                                isForgot = false
                                isRegister = false
                                
                            }
                        }
                        HStack{
                            Text("Đã có tài khoản?")
                                .foregroundColor(.black.opacity(0.3))
                            Button(action: {
                                login = true
                                isForgot = false
                                isRegister = false
                            }, label: {
                                Text("Đăng nhập")
                                    .bold()
                                    .foregroundColor(.black)
                                    
                            })
                        }
                }
            }
        }
        .padding()
    }
    
    /// Execute the clouser and perform hide keyboard in SecuredTextFieldView.
    private func performHideKeyboard() {
        
        guard let hideKeyboard = self.hideKeyboard else {
            return
        }
        
        hideKeyboard()
    }
}
