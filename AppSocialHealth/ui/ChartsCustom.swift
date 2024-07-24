//
//  ChartsCustom.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import SwiftUI
import Charts
struct DataCharts: Identifiable {
    var name: String
    var count: Double
    var color: Color
    var id = UUID()
}

struct ChartsCustom:View {
    @Binding var stackedBarData: [DataCharts]
    @State var text: String
    var body: some View {
        HStack{
            Chart {
                ForEach(stackedBarData) { shape in
                    BarMark(
                        x: .value("Shape Type", shape.name),
                        y: .value("Total Count", shape.count)
                    )
                    .foregroundStyle(shape.color)
                }
            }
            
            
            VStack(alignment: .leading){
                ForEach(stackedBarData) { shape in
                    HStack{
                        Image(systemName: "circle.fill")
                            .foregroundStyle(shape.color)
                        Text("\(shape.name): \(String(format: "%.2f", shape.count))\(text)")
                            .foregroundStyle(.black.opacity(0.3))
                    }
                    
                }
            }
        }
       
    }
}
