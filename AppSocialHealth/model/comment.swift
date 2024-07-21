//
//  comment.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import Foundation
struct CreateComment :Codable {
    var body :String
    var user_id: Int
    var post_id : Int
    var photo : Data?
}
struct CreateCommentNonePhoto :Codable {
    var body :String
    var user_id: Int
    var post_id : Int
}

struct CreateCommentPhoto: Codable {
    var photo_type : String
    var image :Data?
    var url : String
    var post_id : Int?
    var comment_id:Int?
}
struct UpdateComment :Codable {
    var id :Int
    var body :String
    var user_id: Int
    var post_id : Int
}
struct Comment: Codable {
    var id : Int
    var body: String
    var user_id: Int
    var user :User
    var photos: PostPhoto?
}
struct CommentResponse: Codable {
    var data : [Comment]?
}
