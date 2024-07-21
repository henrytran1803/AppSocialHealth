//
//  like.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import Foundation
struct CreateLike: Codable {
    var user_id : Int
    var post_id :Int
}


struct LikeResponse: Codable {
    var data :Bool
}




