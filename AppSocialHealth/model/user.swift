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
    var photo: PhotoUser?


    enum CodingKeys: String, CodingKey {
        case email, firstname, lastname, role, height, weight, bdf, tdee, calorie, id, status,photo
 
    }
}

struct PhotoUser: Codable {
    var id: Int
    var photoType: String
    var image: Data?
    var url: String
    var userId: String
    enum CodingKeys: String, CodingKey {
        case id, photoType = "photo_type", image, url, userId = "user_id"
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
struct UserResponseData: Codable {
    var data : [User]
}
