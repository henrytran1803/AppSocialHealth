//
//  WelcomeView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var isFirstTime : Bool
    var body: some View {
        GeometryReader { geometry in
        VStack {
          
            Button(action: {
                isFirstTime = false
                
                UserDefaults.standard.setValue(false , forKey: "isFirstTime")
             }, label: {
                 HStack {
                     Text("GO TO APP")
                         .bold()
                 }
                 .foregroundColor(.white)
                 .cornerRadius(25)
                 .frame(maxWidth: geometry.size.width * 0.5,maxHeight: 50)
             })
            .buttonStyle(.borderedProminent)
            .tint(.black)
        }
        
        
        
    }
                          }
}

#Preview {
    WelcomeView(isFirstTime: .constant(true))
}
