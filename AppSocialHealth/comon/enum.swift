//
//  enum.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation

import Foundation

enum API {
    static let baseURL = "http://localhost:8080"
    static var bearerToken: String? = nil

    case register
    case login
    case requestPasswordReset
    case confirmPasswordReset
    case createFood
    case updateFood(id: Int)
    case deleteFood(id: Int)
    case getListFood
    case getFood(id: Int)
    case createExercise
    case updateExercise(id: Int)
    case deleteExercise(id: Int)
    case getListExercise
    case getExercise(id: Int)
    case createUser
    case updateUser(id: Int)
    case deleteUser(id: Int)
    case getAllUser
    case getUser(id: Int)
    case createMeal
    case getMealsByUserId(userId: Int)
    case getMeal(id: Int)
    case createMealDetail
    case updateMealDetail(detailId: Int)
    case deleteMeal(id: Int)
    case deleteMealDetail(detailId: Int)
    case createPost
    case likePost
    case deleteLike
    case deletePost(id: Int)
    case createComment
    case updatePost
    case getPost(id: Int)
    case getAllPost
    case getAllComments(postId: Int)
    case createSchedule
    case createScheduleDetail
    case getAllSchedule
    case getSchedule(id: Int)
    case updateSchedule
    case updateScheduleDetail
    case deleteSchedule(id: Int)
    case deleteScheduleDetail(detailId: Int)
    case createConversation
    case sendMessage(conversationId: Int)
    case listUserConversations(userId: Int)
    case listConversationMessages(conversationId: Int)
    case deleteConversation(conversationId: Int)
    case deleteMessage(messageId: Int)
    case createReminder
    case updateReminder(id: Int)
    case getReminder(id: Int)
    case deleteReminder(id: Int)
    case getRemindersByUserId(userId: Int)
    case deletePhotoById(photoId:Int)
    case createPhoto
    case createListPhoto
    case updateFoodNonePhoto
    case updateExersiceNonePhoto
    case dashBoard
    case exType
    case getMealByidAndDate(id : Int, date : String)
    case getInfomationByIdAndDate(id : Int, date : String)
    case getScheduleByidAndDate(id : Int, date : String)
    case getScheduleFromDateToDate(id : Int,fromDate: String, date: String)
    case checkIsLikeUserIdAndPostId(id : Int, post : Int)
    case createCommentNonePhoto
    var path: String {
        switch self {
        case .register:
            return "/v1/account/register"
        case .login:
            return "/v1/account/login"
        case .requestPasswordReset:
            return "/v1/account/requestpassword"
        case .confirmPasswordReset:
            return "/v1/account/confirmpassword"
        case .createFood, .getListFood:
            return "/v1/food"
        case .updateFood(let id), .deleteFood(let id), .getFood(let id):
            return "/v1/food/\(id)"
        case .createExercise, .getListExercise:
            return "/v1/exersice"
        case .updateExercise(let id), .deleteExercise(let id), .getExercise(let id):
            return "/v1/exersice/\(id)"
        case .createUser, .getAllUser:
            return "/v1/user"
        case .updateUser(let id), .deleteUser(let id), .getUser(let id):
            return "/v1/user/\(id)"
        case .createMeal, .getMealsByUserId:
            return "/v1/meal"
        case .getMeal(let id), .deleteMeal(let id):
            return "/v1/meal/\(id)"
        case .createMealDetail:
            return "/v1/meal/detail"
        case .updateMealDetail(let detailId), .deleteMealDetail(let detailId):
            return "/v1/meal/detail/\(detailId)"
        case .createPost, .getAllPost,.updatePost:
            return "/v1/content"
        case .likePost, .deleteLike:
            return "/v1/content/like"
        case .deletePost(let id), .getPost(let id):
            return "/v1/content/\(id)"
        case .createComment:
            return "/v1/content/comment"
        case .getAllComments(let postId):
            return "/v1/content/coment/\(postId)"
        case .createSchedule, .getAllSchedule:
            return "/v1/schedule"
        case .createScheduleDetail:
            return "/v1/schedule/detail"
        case .getSchedule(let id), .deleteSchedule(let id):
            return "/v1/schedule/\(id)"
        case .updateSchedule:
            return "/v1/schedule"
        case  .deleteScheduleDetail(let detailId):
            return "/v1/schedule/detail/\(detailId)"
        case .updateScheduleDetail:
            return "/v1/schedule/detail"
        case .createConversation:
            return "/v1/conversation"
        case .sendMessage(let conversationId):
            return "/v1/conversation/\(conversationId)/messages"
        case .listUserConversations(let userId):
            return "/v1/conversation/users/\(userId)/conversations"
        case .listConversationMessages(let conversationId):
            return "/v1/conversation/\(conversationId)/messages"
        case .deleteConversation(let conversationId):
            return "/v1/conversation/\(conversationId)"
        case .deleteMessage(let messageId):
            return "/v1/conversation/messages/\(messageId)"
        case .createReminder, .getRemindersByUserId:
            return "/v1/reminder"
        case .updateReminder(let id), .getReminder(let id), .deleteReminder(let id):
            return "/v1/reminder/\(id)"
        case .deletePhotoById(let id):
            return "/v1/food/photo/\(id)"
        case .createPhoto:
            return "/v1/food/photo"
        case .createListPhoto:
            return "/v1/food/photos"
        case .updateFoodNonePhoto:
            return "/v1/food"
        case .updateExersiceNonePhoto:
            return "/v1/exersice"
        case .dashBoard:
            return "/v1/account/dashboard"
        case .exType :
            return"/v1/exersice/type"
        case .getMealByidAndDate(let id, let date):
            return"/v1/meal/user/\(id)/date/\(date)"
        case .getScheduleByidAndDate(let id, let date):
            return"/v1/schedule/user/\(id)/date/\(date)"
        case .getInfomationByIdAndDate(let id, let date):
            return"/v1/meal/calorie/user/\(id)/date/\(date)"
        case .getScheduleFromDateToDate(let id,let fromdate, let date):
            return "/v1/schedule/user/\(id)/fromdate/\(fromdate)/date/\(date)"
        case .checkIsLikeUserIdAndPostId(let id, let post):
            return "/v1/content/islike/user/\(id)/post/\(post)"
        case .createCommentNonePhoto:
            return "/v1/content/commentnonephoto"
        }
    }
    var method: String {
        switch self {
        case .register, .login, .requestPasswordReset, .confirmPasswordReset, .createFood, .createExercise, .createUser, .createMeal, .createMealDetail, .createPost, .likePost, .createComment, .createSchedule, .createScheduleDetail, .createConversation, .sendMessage, .createReminder,.createPhoto, .createListPhoto,.createCommentNonePhoto:
            return "POST"
        case .updateFood, .updateExercise, .updateUser, .updateMealDetail, .updatePost, .updateSchedule, .updateScheduleDetail, .updateReminder,.updateFoodNonePhoto,.updateExersiceNonePhoto:
            return "PUT"
        case .deleteFood, .deleteExercise, .deleteUser, .deleteMeal, .deleteMealDetail, .deletePost, .deleteLike, .deleteSchedule, .deleteScheduleDetail, .deleteConversation, .deleteMessage, .deleteReminder,.deletePhotoById:
            return "DELETE"
        case .getListFood, .getFood, .getListExercise, .getExercise, .getAllUser, .getUser, .getMealsByUserId, .getMeal, .getAllPost, .getPost, .getAllComments, .getAllSchedule, .getSchedule, .listUserConversations, .listConversationMessages, .getReminder, .getRemindersByUserId,.dashBoard,.exType, .getMealByidAndDate, .getInfomationByIdAndDate, .getScheduleByidAndDate, .getScheduleFromDateToDate ,.checkIsLikeUserIdAndPostId:
            return "GET"
        }
    }

    var headers: [String: String] {
        var headers = ["Content-Type": "application/json"]
        if let token = API.bearerToken {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    func asURLRequest() -> URLRequest {
        let url = URL(string: API.baseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
