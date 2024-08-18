//
//  meal.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation

struct Meal  : Codable {
    var id : Int
    var user_id: Int
    var description : String
    var date : String
    var total_calorie : Double
    var dishes : [Dish]?
    
}

struct Dish : Codable {
    var id : Int
    var dish_id : Int
    var meal_id : Int
    var serving : Double
    var calorie : Double
}
struct SigleMealResponse: Codable {
    var data : Meal?
}
struct MutiMealResponse: Codable {
    var data : [Meal]
}
struct CreateNewMeal : Codable {
    var user_id : Int
    var dishes : [Mealdetail]
}
struct Mealdetail:Codable {
    var id: Int
    var serving: Double
}
struct MealCreateResponse: Codable {
    var id: Int
}
struct CreateNewMealDetail : Codable {
    var dish_id: Int
    var meal_id: Int
    var serving: Double
}

struct Nutrition : Codable {
    var total_calorie : Double
    var total_protein : Double
    var total_fat : Double
    var total_carb : Double
    var total_sugar : Double
}

struct GetInfomationDate : Codable {
    var schedule :Double
    var meal : Double
    var calorie : Double
    var nutrition : Nutrition
    
}
