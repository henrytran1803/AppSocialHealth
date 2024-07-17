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
    @State private var isOpenDetail = false
    @State var modelInfo = InfomationViewModel()
@State var foodSelected = Food(id: 0, name: "", description: "", calorie: 0, protein: 0, fat: 0, carb: 0, sugar: 0, serving: 0, photos: [])
    @State var id = 0
    @ObservedObject var modelFood = FoodViewModel()
    @State var isLoading = true
    let list = ["Add", "Edit"]
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                LoadingView()
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
                                                if let matchingFood = modelFood.foods.first(where: { $0.id == dish.dish_id }) {
                                                       FoodItemView(
                                                           food: Food(
                                                               id: dish.dish_id,
                                                               name: matchingFood.name,
                                                               description: matchingFood.description,
                                                               calorie: dish.calorie,
                                                               protein: matchingFood.protein,
                                                               fat: matchingFood.fat,
                                                               carb: matchingFood.carb,
                                                               sugar: matchingFood.sugar,
                                                               serving: dish.serving,
                                                               photos: matchingFood.photos
                                                           )
                                                       )
                                                       .onTapGesture {
                                                           foodSelected = matchingFood
                                                           id = dish.id
                                                           isOpenDetail = true
                                                       }
                                                   } else {
                                                       // Xử lý trường hợp không tìm thấy món ăn với id tương ứng
                                                       Text("Food not found")
                                                   }
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
                            
                            
                            SummaryView(carb: modelInfo.info.nutrition.total_carb, fat: modelInfo.info.nutrition.total_fat, sugar: modelInfo.info.nutrition.total_sugar, protein: modelInfo.info.nutrition.total_protein, totalCalories: modelInfo.info.meal, calorieDeficit: modelInfo.info.calorie)
                            HStack{
                                ChartsCustom(stackedBarData: .constant([DataCharts(name: "Protein", count: modelInfo.info.nutrition.total_protein, color: .black.opacity(0.3) ),DataCharts(name: "Carb", count: modelInfo.info.nutrition.total_carb, color: .black.opacity(0.3) ),DataCharts(name: "Fat", count: modelInfo.info.nutrition.total_fat, color: .black.opacity(0.3) ),DataCharts(name: "Sugar", count: modelInfo.info.nutrition.total_sugar, color: .black.opacity(0.3) )]), text: "g")
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
            FoodListView(isOpen: $isOpen, model: modelFood)
            
        }
        .fullScreenCover(isPresented: $isOpenDetail){
            DetailFoodUpdateView(isOpen: $isOpenDetail, id: $id, food: $foodSelected)
        }
        .onAppear {
            isLoading = true
            modelFood.fetchAllFood{
                success in
                if success {
                    model.GetMealByIdAndDate{
                        
                        success in
                        if success {
                            
                            modelInfo.fetchInfoBydate{
                                
                                success in
                                if success {
                                    isLoading = false
                                }else {
                                    
                                }
                            }
                            
                           
                        }else {
                            print("error")
                        }
                    }
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
