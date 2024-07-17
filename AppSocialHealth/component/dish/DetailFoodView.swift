//
//  DetailFoodView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct DetailFoodView: View {
    @State var food : Food
    @State var isAdd = false
    @State private var inputNumber = ""
    @State var alertsuccess = false
    @State var alertfail = false
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack (alignment: .leading){
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(food.photos, id: \.id) { photo in
                                if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                        .padding()
                    }.frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                    Text("Name: \(food.name)")
                    Text("Description: \(food.description)")
                    Text("Calorie: \(food.calorie)")
                    Text("Serving: \(food.serving)")
                    HStack{
                        Text("Fat: \(food.fat)")
                        Text("Carb: \(food.carb)")
                    }
                    HStack{
                        Text("Protein: \(food.protein)")
                        Text("Sugar: \(food.sugar)")
                    }
                    ChartsCustom(stackedBarData: .constant([DataCharts(name: "fat", count: food.fat, color: Color.yellow),DataCharts(name: "carb", count: food.carb, color: Color.black),DataCharts(name: "protein", count: food.protein, color: Color.green),DataCharts(name: "Sugar", count: food.sugar, color: Color.red)]), text: "g")
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                }
            }
        }.navigationTitle(food.name)
            .toolbar{
                Button {
                    isAdd = true
                } label: {
                    Text("ADD")
                }
                
            }
            .alert("Thêm thành công", isPresented: $alertsuccess) {
                Button("OK",role: .cancel){
//                    dismiss()
                }
            }
            .alert("Thêm thất bại", isPresented: $alertfail) {
                Button("OK",role: .cancel){
//                    dismiss()
                }
            }
            .alert("Enter a Number", isPresented: $isAdd) {
                           TextField("Number(g)", text: $inputNumber)
                               .keyboardType(.numberPad)
                           Button("OK", action: {
                               if let num = Double(inputNumber) {
                                   let isMealEmpty = UserDefaults.standard.bool(forKey: "mealEmpty")
                                   print(isMealEmpty)
                                   if isMealEmpty {
                                       MealViewModel().CreateMeal(detail: Mealdetail(id: food.id, serving: num)){success in
                                           if success {
                                               alertsuccess = true
                                           }else {
                                               alertfail = true
                                           }
                                       }
                                   }else {
                                           MealViewModel().CreateMealDetail(dish_id: food.id, serving: num){success in
                                               if success {
                                                   alertsuccess = true
                                               }else {
                                                   alertfail = true
                                               }
                                           }
                                   }
                               }
                           })
                           Button("Cancel", role: .cancel, action: {})
                       } message: {
                           Text("Please enter a serving you eat")
                       }
    }
}
//
//#Preview {
//    DetailFoodView()
//}
