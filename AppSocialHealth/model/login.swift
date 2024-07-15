//
//  login.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation
struct Login : Codable {
    var email : String
    var password :String
}
struct ResponseLoginData: Codable {
    var id: Int
    var token: String
}

struct ResponseLogin: Codable {
    var status: String
    var message: String
    var data: ResponseLoginData
}
