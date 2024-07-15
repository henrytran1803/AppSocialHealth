//
//  loginView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct loginView: View, SecuredTextFieldParentProtocol {
    @Binding var isLogin: Bool
    @Binding var isForgot: Bool
    @Binding var isRegister:Bool
    @Binding var login:Bool
    @State var hideKeyboard: (() -> Void)?
    @State private var password = ""
    @State private var showingAlert = false
    @ObservedObject var modelLogin = LoginViewModel()
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
                        TextFieldView(text: $modelLogin.login.email,title :"Enter Email")
                        SecuredTextFieldView(text:  $modelLogin.login.password, parent: self,title: "Enter Password")
                        HStack{
                            Text("Bạn quên mật khẩu ư?")
                                .foregroundColor(.black.opacity(0.3))
                            Button(action: {
                                isForgot = true
                                isRegister = false
                                login = false
                            }, label: {
                                Text("Lấy lại mật khẩu")
                                    .bold()
                                    .foregroundColor(.black)
                                    
                            })
                        }
                        Button(action: {
                            performHideKeyboard()
                            modelLogin.login{success in
                                if success {
                                    isLogin = true
                                }else {
                                    showingAlert = true
                                }
                                
                            }
                        }, label: {
                            HStack {
                                Text("ĐĂNG NHẬP")
                                    .bold()
                            }
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .frame(maxWidth: geometry.size.width * 0.6,maxHeight: 50)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        .alert(password, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        
                        HStack{
                            Text("Chưa có tài khoản?")
                                .foregroundColor(.black.opacity(0.3))
                            Button(action: {
                                isRegister = true
                                login = false
                                isForgot = false
                            }, label: {
                                Text("Đăng ký")
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


enum Field: Hashable {
    case showPasswordField
    case hidePasswordField
}

struct SecuredTextFieldView: View {
    enum Opacity: Double {

        case hide = 0.0
        case show = 1.0
        mutating func toggle() {
            switch self {
            case .hide:
                self = .show
            case .show:
                self = .hide
            }
        }
    }

    @FocusState private var focusedField: Field?
    @State private var isSecured: Bool = true
    @State private var hidePasswordFieldOpacity = Opacity.show
    @State private var showPasswordFieldOpacity = Opacity.hide
    @Binding var text: String
    @State var parent: SecuredTextFieldParentProtocol
    @State var title : String
    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                securedTextField

                Button(action: {
                    performToggle()
                }, label: {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .accentColor(.gray)
                })
            }.padding()
            .overlay(
               RoundedRectangle(cornerRadius: 5)
                .stroke(.black.opacity(0.3),lineWidth: 2)
            )
        }
        .onAppear {
            self.parent.hideKeyboard = hideKeyboard
        }
    }

    var securedTextField: some View {
        Group {
            SecureField(title, text: $text)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .hidePasswordField)
                .opacity(hidePasswordFieldOpacity.rawValue)

            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .showPasswordField)
                .opacity(showPasswordFieldOpacity.rawValue)
        }
        .padding(.trailing, 32)
        
    }
    func hideKeyboard() {
        self.focusedField = nil
    }
    private func performToggle() {
        isSecured.toggle()

        if isSecured {
            focusedField = .hidePasswordField
        } else {
            focusedField = .showPasswordField
        }

        hidePasswordFieldOpacity.toggle()
        showPasswordFieldOpacity.toggle()
    }
}
protocol SecuredTextFieldParentProtocol {
    var hideKeyboard: (() -> Void)? { get set }
}
struct TextFieldView :View {
    @Binding var text:String
    @State var title : String

    var body: some View {
        Group {
            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
        }
        .padding(.trailing, 32)
        .padding()
        .overlay(
           RoundedRectangle(cornerRadius: 5)
            .stroke(.black.opacity(0.3),lineWidth: 2)
        )
    }
}
