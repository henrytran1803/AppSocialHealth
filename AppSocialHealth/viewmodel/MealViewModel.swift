//
//  MealViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation
class MealViewModel: ObservableObject {
    @Published var meal : Meal = Meal(id: 0, user_id: 0, description: ":", date: Date(primitivePlottable: .now)!, total_calorie: 0)
    
    func GetMealByIdAndDate(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.getMealByidAndDate(id: id, date: getCurrentDateString()).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
        print(getCurrentDateString())
                var request = URLRequest(url: url)
                request.httpMethod = API.getMealByidAndDate(id: id, date: getCurrentDateString()).method
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
                            let meal = try JSONDecoder().decode(SigleMealResponse.self, from: data)
                            self.meal = meal.data ?? Meal(id: 0, user_id: 0, description: "", date: Date(), total_calorie: 0)
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
func getCurrentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: Date())
    return dateString
}
