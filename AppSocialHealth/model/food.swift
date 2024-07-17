//
//  food.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation
struct Food: Codable {
    var id: Int
    var name: String
    var description: String
    var calorie: Double
    var protein: Double
    var fat: Double
    var carb: Double
    var sugar: Double
    var serving: Double
    var photos: [PhotoFood]

    
    enum CodingKeys: String, CodingKey {
        case id, name, description, calorie, protein, fat, carb, sugar, serving, photos
    }
}


struct FoodCreate: Codable {
    var name: String
    var description: String
    var calorie: Double
    var protein: Double
    var fat: Double
    var carb: Double
    var sugar: Double
    var serving: Int
    var photos: [Data]

    
    enum CodingKeys: String, CodingKey {
        case name, description, calorie, protein, fat, carb, sugar, serving, photos
    }
}
struct FoodUpdate: Codable {
    var id: Int
    var name: String
    var description: String
    var calorie: Double
    var protein: Double
    var fat: Double
    var carb: Double
    var sugar: Double
    var serving: Int

    
    enum CodingKeys: String, CodingKey {
        case id, name, description, calorie, protein, fat, carb, sugar, serving
    }
}
struct PhotoFood: Codable {
    var id: Int
    var photoType: String
    var image: Data?
    var url: String
    var dishId: String
    
    enum CodingKeys: String, CodingKey {
        case id, photoType = "photo_type", image, url, dishId = "dish_id"
    }
}

struct FoodResponseData: Codable {
    var data: [Food]
}
