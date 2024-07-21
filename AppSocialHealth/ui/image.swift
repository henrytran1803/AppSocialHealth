//
//  image.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 20/7/24.
//

import SwiftUI

struct MiniCircleimage: View {
    var uiImage: UIImage

    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow,Color.orange, Color.red, Color.red, Color.pink]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 2)
            }
            .shadow(radius: 2)
    }
}

struct SuperMiniCircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15, height: 15)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow,Color.orange, Color.red, Color.red, Color.pink]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 2)
            }
            .shadow(radius: 2)
    }
}
struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color.yellow,Color.orange, Color.red, Color.red, Color.pink]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 2)
            }
            .shadow(radius: 2)
    }
}
