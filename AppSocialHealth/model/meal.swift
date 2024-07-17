//
//  meal.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation
//type GetMeal struct {
//    ID           int        `json:"id" gorm:"primaryKey"`
//    UserId       int        `json:"user_id" gorm:"column:user_id"`
//    Description  string     `json:"description" gorm:"column:description"`
//    Date         *time.Time `json:"date" gorm:"column:date"`
//    TotalCalorie float64    `json:"total_calorie" gorm:"column:total_calorie"`
//    Dishes       []GetDish  `json:"dishes" gorm:"foreignKey:MealId"`
//}
//
//func (GetMeal) TableName() string {
//    return "meals"
//}
//
//type GetDish struct {
//    ID      int     `json:"id" gorm:"primaryKey"`
//    DishId  int     `json:"dish_id" gorm:"column:dish_id"`
//    MealId  int     `json:"meal_id" gorm:"column:meal_id"`
//    Serving float64 `json:"serving" gorm:"column:serving"`
//    Calorie float64 `json:"calorie" gorm:"column:calorie"`
//}
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
