//
//  MealHistoryView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 14/8/24.
//

import SwiftUI

struct MealHistoryView: View {
    @ObservedObject var model = MealHistoryViewModel()
    @State var isLoading = true
    @Binding var isOpen: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            } else {
                NavigationStack {
                    HStack {
                        Button(action: { isOpen = false }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Text("Lịch sử bữa ăn")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(model.meals, id: \.id) { meal in
                                NavigationLink(destination: MealDetailView(meal: meal)) {
                                       MealRowView(meal: meal)
                                   }
                                   
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
        }
        .onAppear {
            model.GetAllMeal { success in
                if success {
                    isLoading = false
                }
            }
        }
    }
}

struct MealRowView: View {
    var meal: Meal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(meal.description)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(formatDate(meal.date))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text("Calories: \(meal.total_calorie, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    // Helper function to format date
    func formatDate(_ date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let parsedDate = isoFormatter.date(from: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: parsedDate)
        }
        return date
    }
}

struct MealDetailView: View {
    @State var isloading = true
    var meal: Meal
    @ObservedObject var model = FoodViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal Details")
                .font(.largeTitle)
                .padding(.bottom)
            
            Text("Description: \(meal.description)")
                .font(.headline)
            
            Text("Date: \(meal.date)")
                .font(.subheadline)
            
            Text("Total Calories: \(meal.total_calorie, specifier: "%.1f")")
                .font(.subheadline)
            
            if let dishes = meal.dishes {
                Text("Dishes:")
                    .font(.headline)
                    .padding(.top)
                ForEach(dishes, id: \.id) { dish in
                    VStack(alignment: .leading) {
                        if let matchingFood = model.foods.first(where: { $0.id == dish.dish_id }) {
                               FoodItemView(
                                   food: Food(
                                       id: dish.dish_id,
                                       name: matchingFood.name,
                                       description: matchingFood.description,
                                       calorie: (dish.serving * matchingFood.calorie) / matchingFood.serving,
                                       protein: matchingFood.protein,
                                       fat: matchingFood.fat,
                                       carb: matchingFood.carb,
                                       sugar: matchingFood.sugar,
                                       serving: dish.serving,
                                       photos: matchingFood.photos
                                   )
                               )
                               
                           } else {
                               Text("Food not found")
                           }
                    }
                    .padding(.bottom, 8)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle(Text("Meal Details"), displayMode: .inline)
        .onAppear{
            model.fetchAllFood{
                success in
                if success {
                    isloading = false
                }
            }
        }
    }
}
