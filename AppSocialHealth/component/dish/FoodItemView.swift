//
//  FoodItemView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI


struct FoodItemView: View {
    @State var food: Food
    
    var body: some View {
        HStack {
            if let imageData = food.photos.first?.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(food.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Calorie: \(String(format: "%.2f", food.calorie)) cal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Serving: \(String(format: "%.2f", food.serving))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding([.leading, .trailing, .top], 10)
    }
}

