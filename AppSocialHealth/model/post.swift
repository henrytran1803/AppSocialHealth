//
//  post.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import Foundation

struct CreatePost: Codable {
    var title: String
    var body : String
    var user_id:Int
    var photos: Data?
}
struct UpdatePost : Codable {
    var id :Int
    var title: String
    var body : String
    var user_id:Int
}
struct PostResponse : Codable {
    var data: [Post]?
}

struct Post: Codable {
    var id: Int
    var title: String
    var body: String
    var user_id : Int
    var count_likes: Int
    var count_comments : Int
    var photos : [PostPhoto]
    var user: User

}
struct PostPhoto: Codable {
    var id: Int
    var photo_type: String
    var image: Data
    var url: String
    var post_id: String
    var comment_id: String
}
