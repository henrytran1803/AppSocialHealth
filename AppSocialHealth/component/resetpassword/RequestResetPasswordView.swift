//
//  RequestResetPasswordView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct RequestResetPasswordView: View, SecuredTextFieldParentProtocol {
    @Binding var login :Bool
    @Binding var isForgot :Bool
    @Binding var isRegister :Bool
    @ObservedObject var  model = ResetPasswordViewModel()
    @State var email = ""
    @State var hideKeyboard: (() -> Void)?
    @State var showingAlert = false
    @Binding var isConfirm:Bool
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                        VStack(alignment: .leading){
                            Text("RESET!")
                                .font(.title)
                                .bold()
                            Text("Please enter your email to resetpass")
                                .foregroundColor(.black.opacity(0.5))
                        }.padding(.bottom, 50)
                    VStack(alignment: .center, spacing: 20) {
                        TextFieldView(text: $email,title :"Enter Email")

                        Button(action: {
                            performHideKeyboard()
                            model.requestResetPass(email: email){success in
                                if success {
                                    isConfirm = true
                                    isRegister = false
                                    login = false
                                    isForgot = false
                                }else {
                                    showingAlert = true
                                }
                                print(model.errorMessage)
                                
                            }
                        }, label: {
                            HStack {
                                Text("GỬI")
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
                        HStack{
                            Text("Bạn đã nhớ mật khẩu ư?")
                                .foregroundColor(.black.opacity(0.3))
                            Button(action: {
                                isForgot = false
                                isRegister = false
                                login = true
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
