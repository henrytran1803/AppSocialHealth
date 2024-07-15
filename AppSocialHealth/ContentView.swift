//
//  ContentView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    @State  var isLogin : Bool = true
    @State  var login : Bool = true
    @State var isForgot :Bool = false
    @State var isRegister : Bool = false
    @State var isFirstTime :Bool = false
    @State var isConfirm:Bool = false

    var body: some View {
        VStack {
            if isFirstTime {
                WelcomeView(isFirstTime : $isFirstTime)
            }else {
                
                
                
                if isLogin {
                    homeView(isLogin: $isLogin)
                }else {
                    if login {
                        loginView(isLogin: $isLogin, isForgot: $isForgot, isRegister: $isRegister,login: $login)
                    }
                    if isForgot {
                        RequestResetPasswordView(login: $login, isForgot: $isForgot, isRegister: $isRegister,isConfirm : $isConfirm)
                    }
                    if isRegister
                    {
                        registerView(login: $login, isForgot: $isForgot, isRegister: $isRegister )
                    }
                    if isConfirm {
                        ConfirmResetView(login: $login, isForgot: $isForgot, isRegister: $isRegister,isConfirm : $isConfirm)
                    }
                }
            }
            
        }.onAppear{
            isLogin = UserDefaults.standard.bool(forKey: "isLogin")
            isFirstTime = UserDefaults.standard.bool(forKey: "isFirstTime")
        }
    }
}

#Preview {
    ContentView()
}
