//
//  user.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import Foundation
struct User: Codable {
    var email: String
    var firstname: String
    var lastname: String
    var role: Int
    var height: Double
    var weight: Double
    var bdf: Double
    var tdee: Double
    var calorie: Double
    var id: Int
    var status: Int


    enum CodingKeys: String, CodingKey {
        case email, firstname, lastname, role, height, weight, bdf, tdee, calorie, id, status
 
    }
}

struct UserUpdate:Codable {
    var id: Int
    var email: String
    var firstname: String
    var lastname: String
    var role: Int
    var height: Double
    var weight: Double
    var bdf: Double
    var tdee: Double
    var calorie: Double
    var status: Int
}
 
struct GetUserResponse: Codable{
    var data: User
}
