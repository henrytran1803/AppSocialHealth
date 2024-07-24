//
//  DetailFoodView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//
import SwiftUI

struct DetailFoodView: View {
    @State var food: Food
    @State var isAdd = false
    @State private var inputNumber = ""
    @State var alertSuccess = false
    @State var alertFail = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(food.photos, id: \.id) { photo in
                                if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                        .clipped()
                                        .cornerRadius(10)
                                } else {
                                    ProgressView()
                                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(food.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(food.description)
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        Text("Calorie: \(food.calorie, specifier: "%.2f") cal")
                            .font(.headline)
                        
                        Text("Serving: \(food.serving, specifier: "%.2f") g")
                            .font(.subheadline)
                        
                        HStack(spacing: 20) {
                            Text("Fat: \(food.fat, specifier: "%.2f") g")
                            Text("Carb: \(food.carb, specifier: "%.2f") g")
                        }
                        .font(.subheadline)
                        
                        HStack(spacing: 20) {
                            Text("Protein: \(food.protein, specifier: "%.2f") g")
                            Text("Sugar: \(food.sugar, specifier: "%.2f") g")
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    
                    ChartsCustom(
                        stackedBarData: .constant([
                            DataCharts(name: "Fat", count: food.fat, color: Color.yellow),
                            DataCharts(name: "Carb", count: food.carb, color: Color.black),
                            DataCharts(name: "Protein", count: food.protein, color: Color.green),
                            DataCharts(name: "Sugar", count: food.sugar, color: Color.red)
                        ]),
                        text: "g"
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                }
                .padding()
            }
        }
        .navigationTitle(food.name)
        .toolbar {
            Button {
                isAdd = true
            } label: {
                Text("ADD")
                    .font(.headline)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .alert("Thêm thành công", isPresented: $alertSuccess) {
            Button("OK", role: .cancel) {}
        }
        .alert("Thêm thất bại", isPresented: $alertFail) {
            Button("OK", role: .cancel) {}
        }
        .alert("Enter a Number", isPresented: $isAdd) {
            VStack {
                Text("Please enter a serving you eat")
                TextField("Number (g)", text: $inputNumber)
                    .keyboardType(.numberPad)
                HStack {
                    Button("OK") {
                        if let num = Double(inputNumber) {
                            let isMealEmpty = UserDefaults.standard.bool(forKey: "mealEmpty")
                            if isMealEmpty {
                                MealViewModel().CreateMeal(detail: Mealdetail(id: food.id, serving: num)) { success in
                                    alertSuccess = success
                                    alertFail = !success
                                }
                            } else {
                                MealViewModel().CreateMealDetail(dish_id: food.id, serving: num) { success in
                                    alertSuccess = success
                                    alertFail = !success
                                }
                            }
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
}
