//
//  Photo.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import Foundation
struct PhotoBase :Codable{
    var photo_type: String
    var image: Data?
    var url: String
    var dish_id: String?
    var exersice_id: String?
    var post_id: String?
    var comment_id: String?
    var user_id: String?
}
