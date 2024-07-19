//
//  MealViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation
class MealViewModel: ObservableObject {
    @Published var meal : Meal = Meal(id: 0, user_id: 0, description: ":", date: "", total_calorie: 0)
    
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
                            self.meal = meal.data ?? Meal(id: 0, user_id: 0, description: "", date: "", total_calorie: 0)
                            if meal.data == nil {
                                UserDefaults.standard.setValue(true, forKey: "mealEmpty")
                                UserDefaults.standard.setValue(self.meal.id, forKey: "mealId")
                            }else {
                                UserDefaults.standard.setValue(false, forKey: "mealEmpty")
                                UserDefaults.standard.setValue(self.meal.id, forKey: "mealId")
                            }
                            completion(true)
                        } catch {
                            print("Failed to decode JSON: \(error.localizedDescription)")
                            completion(false)
                        }
                    }
                }
                dataTask.resume()
            }
    
    func CreateMeal(detail: Mealdetail,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        var meal = CreateNewMeal(user_id: id, dishes: [detail])
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createMeal.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createMeal.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(meal)
                    request.httpBody = jsonData
                } catch {
                    print("Error encoding user input: \(error.localizedDescription)")
                    completion(false)
                    return
                }
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
                            let meal = try JSONDecoder().decode(MealCreateResponse.self, from: data)
                            UserDefaults.standard.setValue(meal.id, forKey: "mealId")
                                UserDefaults.standard.setValue(false, forKey: "mealEmpty")
                            print(meal)
                            completion(true)
                        } catch {
                            print("Failed to decode JSON: \(error.localizedDescription)")
                            completion(false)
                        }
                    }
                }
                dataTask.resume()
        
    }
    func CreateMealDetail(dish_id: Int, serving: Double,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        let mealid = UserDefaults.standard.integer(forKey: "mealId")

        var mealdetail = CreateNewMealDetail(dish_id: dish_id, meal_id: mealid, serving: serving)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createMealDetail.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createMealDetail.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(mealdetail)
                    request.httpBody = jsonData
                } catch {
                    print("Error encoding user input: \(error.localizedDescription)")
                    completion(false)
                    return
                }
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
                        completion(true)
                    }
                }
                dataTask.resume()
        
    }
    func UpdateMealDetail(mealDetailId: Int,dish_id: Int, serving: Double,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        let mealid = UserDefaults.standard.integer(forKey: "mealId")
        var mealdetail = CreateNewMealDetail(dish_id: dish_id, meal_id: mealid, serving: serving)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.updateMealDetail(detailId: mealDetailId).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.updateMealDetail(detailId: mealDetailId).method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(mealdetail)
                    request.httpBody = jsonData
                } catch {
                    print("Error encoding user input: \(error.localizedDescription)")
                    completion(false)
                    return
                }
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
                        completion(true)
                    }
                }
                dataTask.resume()
        
    }
    func DeleteMealDetail(mealDetailId: Int,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.deleteMealDetail(detailId: mealDetailId).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.deleteMealDetail(detailId: mealDetailId).method
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
                        completion(true)
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
