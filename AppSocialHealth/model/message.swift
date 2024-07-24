//
//  message.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import Foundation


struct MessageConvertion: Codable {
    var users: [User]?
    var messages: [Message]
}
struct Message: Codable {
    var id: Int
    var conversation_id: Int
    var sender_id : Int
    var content: String
    var timestamp : String
}
struct Convertion: Codable{
    var id: Int
    var created_at: String
    var participants: [Int]
    var users: [User]
}

struct SendMessage: Codable{
    var conversation_id: Int
    var sender_id: Int
    var content: String
}

struct CreateConversation: Codable {
    var participants : [Int]
}
