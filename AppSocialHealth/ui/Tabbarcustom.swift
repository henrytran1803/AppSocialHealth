//
//  Tabbarcustom.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case dish
    case exersice
    case content
    case chat
    case profile
}
struct TabBarCustom: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image( selectedTab == tab ? fillImage : tab.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: selectedTab == tab ? 25 :20)
                        .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 70)
            
            .background(Color(.white))
            .cornerRadius(20)
            
            .overlay{
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black.opacity(0.3),lineWidth: 3)
            }
            .padding()
        }
    }
}
