//
//  exersice.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import Foundation
struct Exercise : Codable{
    var id :Int
    var name: String
    var description: String
    var calorie : Double
    var rep_serving: Int
    var time_serving:Int
    var exersice_type : ExersiceType
    var photo: [PhotoExersice]
    enum CodingKeys: String, CodingKey {
        case id, name, description, calorie, rep_serving, time_serving, exersice_type, photo
    }
}


struct ExersiceCreate  : Codable{
    var name: String
    var description: String
    var calorie : Double
    var rep_serving: Int
    var time_serving:Int
    var exersice_type : Int
    var image: [Data]
}


struct ExersiceUpdate : Codable {
    var id :Int
    var name: String
    var description: String
    var calorie : Double
    var rep_serving: Int
    var time_serving:Int
    var exersice_type : Int
}
struct ExersiceType  : Codable, Identifiable{
    var id : Int
    var name : String
}

struct PhotoExersice: Codable {
    var id: Int
    var photoType: String
    var image: Data?
    var url: String
    var exersiceId: String
    enum CodingKeys: String, CodingKey {
        case id, photoType = "photo_type", image, url, exersiceId = "exersice_id"
    }
}


struct ExersiceResponseData: Codable {
    var data: [Exercise]
}
