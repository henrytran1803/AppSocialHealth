//
//  CustomProgressView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import SwiftUI

struct NutritionProgressView: View {
  let progress: CGFloat
    let color :Color
    let label: String
    let value: Double
  var body: some View {
    GeometryReader { geometry in
        VStack{
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(
                        width: min(progress * geometry.size.width,
                                   geometry.size.width),
                        height: 10
                    )
                    .foregroundColor(color)
            }
            Text("\(label) \(value * 100, specifier: "%.2f")%")
        }
    }
  }
}
struct ProgressBar: View {
    @Binding var progress: Double
    @State var color: Color
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
        }
    }
}
