//
//  profileView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct profileView: View {
    @Binding var isLogin :Bool
    var body: some View {
        VStack {
            
            Button(action: {
                isLogin = false
               LoginViewModel().logout()
            }, label: {Text("logout").foregroundColor(.black)})
        }
    }
}

