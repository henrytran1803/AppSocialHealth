//
//  ConfirmResetView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct ConfirmResetView: View, SecuredTextFieldParentProtocol {
    @Binding var login :Bool
    @Binding var isForgot :Bool
    @Binding var isRegister :Bool
    @ObservedObject var  model = ResetPasswordViewModel()
    @State var hideKeyboard: (() -> Void)?
    @State var showingAlert = false
    @State var showingAlertSuccess = false
    @Binding var isConfirm:Bool
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                        VStack(alignment: .leading){
                            Text("Confirm!")
                                .font(.title)
                                .bold()
                            
                            Text("Please check your email and get token")
                                .foregroundColor(.black.opacity(0.5))
                        }.padding(.bottom, 50)
                    VStack(alignment: .center, spacing: 20) {
                        TextFieldView(text: $model.resetPass.token,title :"Enter Token")
                        SecuredTextFieldView(text:   $model.resetPass.new_password, parent: self,title: "Enter Password")
                        Button(action: {
                            performHideKeyboard()
                            model.resetPass(){success in
                                if success {
                                    showingAlertSuccess = true
                                }else {
                                    showingAlert = true
                                }
                                
                            }
                        }, label: {
                            HStack {
                                Text("RESET")
                                    .bold()
                            }
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .frame(maxWidth: geometry.size.width * 0.6,maxHeight: 50)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .alert("password", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        .alert("Thành công", isPresented: $showingAlertSuccess) {
                            Button("OK", role: .cancel) { }
                            Button("Quay lại đăng nhập", role: .destructive) {
                                isRegister = false
                                login = true
                                isForgot = false
                                isConfirm = false
                            }
                        }
                        HStack{
                            Text("Trở về đăng nhập?")
                                .foregroundColor(.black.opacity(0.3))
                            Button(action: {
                                isRegister = false
                                login = true
                                isForgot = false
                                isConfirm = false
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
    
    private func performHideKeyboard() {
        
        guard let hideKeyboard = self.hideKeyboard else {
            return
        }
        
        hideKeyboard()
    }
}
