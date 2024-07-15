//
//  homeView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct homeView: View {
    @Binding var isLogin : Bool
    var body: some View {
        VStack{
            Button(action: {
                isLogin = false
               LoginViewModel().logout()
            }, label: {Text("logout")})
        }
    }
}


struct TabView: View {
    @State private var tabSelected: Tab = .house

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack {
            VStack {
//                switch tabSelected {
//                case .house:
////                    HomeView()
//                case .cart:
////                    CartView()
//                case .person:
////                    SettingView()
//                }

                Spacer()
            }
            VStack {
                Spacer()
                TabBarCustom(selectedTab: $tabSelected)
                
            }
        }.ignoresSafeArea()
    }
}
