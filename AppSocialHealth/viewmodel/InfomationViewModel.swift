//
//  InfomationViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import Foundation
class InfomationViewModel: ObservableObject {
    @Published var info = GetInfomationDate(schedule: 0, meal: 0, calorie: 0, nutrition: Nutrition(total_calorie: 0, total_protein: 0, total_fat: 0, total_carb: 0, total_sugar: 0))
    
    
    func fetchInfoBydate(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.getInfomationByIdAndDate(id: id, date: getCurrentDateString()).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.getInfomationByIdAndDate(id: id, date: getCurrentDateString()).method
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
                    let exResponse = try JSONDecoder().decode(GetInfomationDate.self, from: data)
                    self.info = exResponse
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
