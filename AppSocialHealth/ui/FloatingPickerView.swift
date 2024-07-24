//
//  FloatingPickerView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import SwiftUI


struct FloatingPickerView: View {
    @State private var isPickerVisible = false
    @Binding var selected: String
    let list: [String]
    
    var body: some View {
        ZStack {
            if isPickerVisible {
                ZStack {
                    ForEach(0..<list.count, id: \.self) { index in
                        Button(action: {
                            selected = list[index]
                            isPickerVisible = false
                        }) {
                            Text(list[index])
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }.overlay{
                            Circle()
                                .stroke(.black.opacity(0.3), lineWidth: 3)
                        }
                        .offset(x: 0, y: -CGFloat(60 * (index + 1)))
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    isPickerVisible.toggle()
                }
            }) {
                Image(systemName: isPickerVisible ? "xmark" : "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(isPickerVisible ? Color.red.opacity(0.3) : Color.red)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}
