//
//  Register.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//
import Foundation
struct Register: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var role: Int
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "firstname"
        case lastName = "lastname"
        case role
        case password
    }
}

struct RegisterData: Codable {
    var status: String
    var message: String
    var data: Register
}
//{
//    "status": "success",
//    "message": "Account created",
//    "data": {
//        "email": "exampleee@example33333.com",
//        "firstname": "",
//        "lastname": "Doe",
//        "role": 1,
//        "password": "securepassword"
//    }
//}
