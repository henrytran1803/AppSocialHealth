//
//  ContentView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 3/7/24.
//

import SwiftUI

// ContentView.swift
struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel()

    var body: some View {
        VStack {
            if loginViewModel.isFirstTime {
                WelcomeView(isFirstTime: $loginViewModel.isFirstTime)
            } else {
                if loginViewModel.isLogin {
                    TabBarView(isLogin: $loginViewModel.isLogin)
                } else {
                    AuthenticationView()
                        .environmentObject(loginViewModel)
                }
            }
        }
        .onAppear {
            loginViewModel.checkToken { success in
                if !success {
                    loginViewModel.logout()
                }
            }
        }
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var login = true
    @State private var isForgot = false
    @State private var isRegister = false
    @State private var isConfirm = false

    var body: some View {
        VStack {
            if login {
                loginView(isLogin: $loginViewModel.isLogin, isForgot: $isForgot, isRegister: $isRegister, login: $login)
            }
            if isForgot {
                RequestResetPasswordView(login: $login, isForgot: $isForgot, isRegister: $isRegister, isConfirm: $isConfirm)
            }
            if isRegister {
                registerView(login: $login, isForgot: $isForgot, isRegister: $isRegister)
            }
            if isConfirm {
                ConfirmResetView(login: $login, isForgot: $isForgot, isRegister: $isRegister, isConfirm: $isConfirm)
            }
        }
    }
}
