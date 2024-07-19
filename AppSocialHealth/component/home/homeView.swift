//
//  homeView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI
import Charts


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

struct homeView: View {
    @State var searchText = ""
    @State private var selected = ""
    let list = ["Add", "Edit"]
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    HStack{
                        Text("Lịch ăn hôm nay")
                            .bold()
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.2))
                            TextField("Search", text: $searchText)
                            
                        }.padding([.leading, .trailing])
                            .overlay{
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black.opacity(0.2),lineWidth: 2)
                            }
                    }.padding([.leading, .trailing])
                    SummaryView(carb: 10, fat: 10, sugar: 10, protein: 10, totalCalories: 10, calorieDeficit: 10)
                    
                    HStack{
                        ChartsCustom(stackedBarData: .constant([DataCharts(name: "Protein", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Carb", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Fat", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Sugar", count: 10, color: .black.opacity(0.3) )]), text: "g")
                            .frame( height: geometry.size.height * 0.4)
                    }
                    Spacer()
                    
                }
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingPickerView(selected: $selected, list: list)
                    }
                }
                
            }
        }
        .onAppear {
            print("Selected item: \(selected)")
        }
    }
}
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

struct SummaryView: View {
    let carb: Double
    let fat: Double
    let sugar: Double
    let protein: Double
    let totalCalories: Double
    let calorieDeficit: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tổng kết")
                .bold()
                .font(.headline)
                .foregroundColor(.red)
                .underline()

            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Carb:\(String(format: "%.2f", carb))g")
                    Text("Sugar: \(String(format: "%.2f", sugar))g")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Fat: \(String(format: "%.2f", fat))g")
                    Text("Protein: \(String(format: "%.2f", protein))g")
                }
            }
            Text("Tổng calories : \(String(format: "%.2f", totalCalories)) calo")
                .font(.headline)
                .fontWeight(.bold)
            if calorieDeficit > 0 {
                Text("*Còn thiếu so với bạn \(String(format: "%.2f", calorieDeficit)) calo")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
struct TabBarView: View {
    @State private var tabSelected: Tab = .home
    @Binding var isLogin : Bool

    init(isLogin: Binding<Bool>) {
           self._isLogin = isLogin
           UITabBar.appearance().isHidden = true
       }

    var body: some View {
        ZStack {
            
            VStack {
                switch tabSelected {
                case .home:
                    homeView()
                case .dish:
                    dishView()
                case .exersice:
                    exersiceView()
                case .content:
                    contentView()
                case .chat :
                    chatView()
                case .profile:
                    profileView(isLogin: $isLogin)
                }
            
                Spacer()
                TabBarCustom(selectedTab: $tabSelected)
            }.background(.gray.opacity(0.2))
        }.edgesIgnoringSafeArea([.bottom, .trailing,. leading])
    }
}
