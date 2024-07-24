//
//  Reminder.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import Foundation


struct ReminderCreate : Codable  {
    var user_id : Int
    var description : String
    var schedule_id : Int?
    var meal_id : Int?
    var reminder_type_id : Int
    var date  : String
    var status : Int = 0
}

struct Reminder : Codable  {
    var id : Int
    var user_id : Int
    var description : String
    var schedule_id : Int?
    var meal_id : Int?
    var reminder_type_id : Int
    var date  : String
    var status : Int
}


struct ReminderResponse : Codable  {
    var data : [Reminder]
}
