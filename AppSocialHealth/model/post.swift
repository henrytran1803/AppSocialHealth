//
//  post.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import Foundation
//type CreatePostFull struct {
//    Title       string        `json:"title" gorm:"column:title" form:"title" `
//    Body        string        `json:"body" gorm:"column:body" form:"body" `
//    UserId      int64         `json:"user_id" gorm:"column:user_id" form:"user_id" `
//    CreatePhoto []CreatePhoto `json:"photos" form:"photos" `
//}
struct CreatePost: Codable {
    var title: String
    var body : String
    var user_id:Int
    var photos: [CreateCommentPhoto]
}
struct UpdatePost : Codable {
    var id :Int
    var title: String
    var body : String
    var user_id:Int
}

struct Post: Codable {
    var id: Int
    var title: String
    var body: String
    var user_id : Int
    var count_like: Int
    var count_comment : Int
    var photos : [PostPhoto]
}
struct PostPhoto: Codable {
    var id: Int
    var photo_type: String
    var image: Data
    var url: String
    var post_id: String
}

//type CreateLike struct {
//    UserId int64 `json:"user_id" gorm:"column:user_id"`
//    PostId int64 `json:"post_id" gorm:"column:post_id"`
//}
//type GetPost struct {
//    ID             int     `json:"id" gorm:"column:id"`
//    Title          string  `json:"title" gorm:"column:title"`
//    Body           string  `json:"body" gorm:"column:body"`
//    UserId         int64   `json:"user_id" gorm:"column:user_id"`
//    Photos         []Photo `json:"photos"`
//    Count_likes    int     `json:"count_likes" `
//    Count_comments int     `json:"count_comments" `
//}
//type GetComment struct {
//    ID     int    `json:"id" gorm:"column:id"`
//    Body   string `json:"body" gorm:"column:body"`
//    UserId int64  `json:"user_id" gorm:"column:user_id"`
//    Name   string `json:"name" `
//    Photo  Photo  `json:"photos"`
//}
//type Photo struct {
//    Id         int    `json:"id" gorm:"column:id"`
//    Photo_type string `json:"photo_type" gorm:"column:photo_type"`
//    Image      []byte `json:"image" gorm:"column:image"`
//    Url        string `json:"url" gorm:"column:url"`
//    Post_id    string `json:"post_id" gorm:"column:post_id"`
//}
