//
//  TabbarView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    @State private var tabSelected: Tab = .home
    @Binding var isLogin : Bool

    init(isLogin: Binding<Bool>) {
           self._isLogin = isLogin
           UITabBar.appearance().isHidden = true
       }

    var body: some View {
        if !isFirstLaunch {
                OnboardingView(isFirstLaunch: $isFirstLaunch)
        } else {
            
            ZStack {
                VStack {
                    switch tabSelected {
                    case .home:
                        homeView()
                    case .dish:
                        dishView()
                    case .exersice:
                        exersiceView()
                    case .content:
                        contentView()
                    case .chat :
                        ChatView()
                    case .profile:
                        ProfileView(isLogin: $isLogin)
                    }
                    
                    Spacer()
                    TabBarCustom(selectedTab: $tabSelected)
                }.background(.gray.opacity(0.2))
            }.edgesIgnoringSafeArea([.bottom, .trailing,. leading])
        }
    }
    
}
