//
//  FoodItemView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct FoodItemView: View {
    @State var food : Food
    var body: some View {
            HStack{
                if let imageData = food.photos.first?.image, let uiImage = UIImage(data: imageData) {
                                  Image(uiImage: uiImage)
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(width: 100)
                              } else {
                                  ProgressView()
                              }
                Spacer()
                Text("Name:\(food.name)")
                    .foregroundColor(.black)
                Spacer()
                VStack{
                    Text("Calorie:\(food.calorie)")
                        .foregroundColor(.black.opacity(0.3))
                    Text("Serving:\(food.serving)")
                        .foregroundColor(.black.opacity(0.3))
                }
                
               
            }.frame(height: 110)
            .overlay {
                Rectangle()
                    .stroke( .black.opacity(0.3),lineWidth:3)
            }
            .padding([.leading, .trailing])
        }
}

//#Preview {
//    FoodItemView()
//}
