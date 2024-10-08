//
//  ScheduleHistoryViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 14/8/24.
//

import Foundation
class ScheduleHistoryViewModel: ObservableObject {
    
    @Published var schedules : [Schedule] = []
    
    func GetAllMeal(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.getScheduleByUserId(id: id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.getScheduleByUserId(id: id).method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response from server")
                    completion(false)
                    return
                }
                
                guard let data = data else {
                    print("No data received from server")
                    completion(false)
                    return
                }
                do {
                    let meal = try JSONDecoder().decode(ScheduleAllUser.self, from: data)
                    self.schedules = meal.data
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
}

