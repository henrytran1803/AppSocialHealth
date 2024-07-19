//
//  ExersiceItemView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import SwiftUI

struct ExersiceItemView: View {
    @State var exersice : Exersice
    var body: some View {
            HStack{
                if let imageData = exersice.photo.first?.image, let uiImage = UIImage(data: imageData) {
                                  Image(uiImage: uiImage)
                                      .resizable()
                                      .aspectRatio(contentMode: .fit)
                                      .frame(width: 100)
                              } else {
                                  ProgressView()
                              }
                Spacer()
                Text("Name:\(exersice.name)")
                    .foregroundColor(.black)
                Spacer()
                VStack{
                    Text("Calorie: \(String(format: "%.2f", exersice.calorie))")
                        .foregroundColor(.black.opacity(0.3))
                    Text("Serving: \(String(format: "%.2f", exersice.rep_serving == 0 ? exersice.time_serving : exersice.rep_serving ))")
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

