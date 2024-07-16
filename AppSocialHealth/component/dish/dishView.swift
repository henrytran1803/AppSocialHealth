//
//  dishView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct dishView: View {
    @ObservedObject var model = MealViewModel()
    @State var searchText = ""
    @State private var selected = ""
    @State private var isOpen = false
    
    @State var isLoading = true
    let list = ["Add", "Edit"]
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                ProgressView()
            }else {
                ZStack{
                    ScrollView{
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
                            VStack {
                                ScrollView {
                                    if let dishes = model.meal.dishes {
                                        if dishes.isEmpty {
                                            Text("It's empty")
                                        } else {
                                            ForEach(dishes, id: \.id) { dish in
                                                Text("\(dish.id)")
                                            }
                                        }
                                    } else {
                                        Text("It's empty")
                                    }
                                }
                            }.frame(height: geometry.size.height * 0.5)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black.opacity(0.3),lineWidth: 3)
                                }
                            
                            
                            SummaryView(carb: 10, fat: 10, sugar: 10, protein: 10, totalCalories: 10, calorieDeficit: 10)
                            HStack{
                                ChartsCustom(stackedBarData: .constant([DataCharts(name: "Protein", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Carb", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Fat", count: 10, color: .black.opacity(0.3) ),DataCharts(name: "Sugar", count: 10, color: .black.opacity(0.3) )]), text: "%")
                                    .frame( height: geometry.size.height * 0.4)
                            }
                            Spacer()
                            
                        }
                       
                        
                    }
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            FloatingPickerView(selected: $selected, list: list)
                        }
                    }
                   .onChange(of: selected) { newValue in
                       if newValue == "Add" {
                           isOpen = true
                       } else {
                       }
                   }
                }
            }
               

        } .fullScreenCover(isPresented: $isOpen){
            FoodListView(isOpen: $isOpen)
        }
        .onAppear {
            isLoading = true
            model.GetMealByIdAndDate{
                success in
                if success {
                    isLoading = false
                }else {
                    print("error")
                }
            }
           
        }
    }
}

#Preview {
    dishView()
}
