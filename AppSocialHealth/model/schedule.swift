//
//  schedule.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import Foundation
struct Schedule : Codable {
    var id :Int
    var user_id : Int
    var time : String
    var calories : Double
    var status : Int
    var create_at : String?
    var detail : [Schedule_Detail]?
}

struct ScheduleFromDateToDate : Codable {
    
    var data : [Schedule]?
    
}
struct ScheduleResponse : Codable {
    var data : Schedule?
}
struct Schedule_Detail : Codable {
    var id :Int
    var schedule_id :Int
    var exersice_id :Int
    var rep :Int
    var time :Int
}
struct ScheduleUpdate : Codable{
    var id : Int
    var user_id : Int
    var time : String
}
struct ScheduleDetailCreate :Codable {
    var schedule_id :Int
    var exersice_id :Int
    var rep: Int
    var time : Int
}
struct ScheduleDetailCreateSigle :Codable {
    var exersice_id :Int
    var rep: Int
    var time : Int
}
struct ScheduleCreateFull :Codable {
    var user_id : Int
    var time : String
    var detail : [ScheduleDetailCreateSigle]
}
struct ScheduleCreateResponse : Codable {
    var id :Int
}
struct ScheduleAllUser: Codable {
    var data : [Schedule]
}
//{
//    "user_id": 3,
//    "time": null,
//    "detail": [
//        {
//            "exersice_id": 3,
//            "rep": 3,
//            "time":0
//        }
//    ]
//}

//type ScheduleCreate struct {
//    ID      int       `json:"id" gorm:"column:id;"`
//    User_id int64     `json:"user_id" gorm:"column:user_id;not null"`
//    Time    time.Time `json:"time" gorm:"column:time;not null"`
//}
//type ScheduleDetailCreate struct {
//    ID          int `json:"id" gorm:"column:id;"`
//    Schedule_id int `json:"schedule_id" gorm:"column:schedule_id;not null"`
//    Exersice_id int `json:"exersice_id" gorm:"column:exersice_id;not null"`
//    Rep         int `json:"rep" gorm:"column:rep"`
//    Time        int `json:"time" gorm:"column:time"`
//}
// create fisttime
//type ScheduleCreateFull struct {
//    User_id int64                  `json:"user_id" gorm:"column:user_id;not null"`
//    Time    time.Time              `json:"time" gorm:"column:time;not null"`
//    Detail  []ScheduleDetailCreate `json:"detail"`
//}
