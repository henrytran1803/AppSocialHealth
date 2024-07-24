//
//  ReminderModelView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//

import Foundation
class ReminderModelView: ObservableObject {
    @Published var reminders :[Reminder] = []
    
    
    func fetchAllReminderById(completion: @escaping (Bool) -> Void) {
        let id =  UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.getRemindersByUserId(userId: id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.getRemindersByUserId(userId: id).method
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
                    let reminders = try JSONDecoder().decode(ReminderResponse.self, from: data)
                    self.reminders = reminders.data
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
    func createReminder(reminder : ReminderCreate,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        var newReminder = reminder
        newReminder.user_id = id
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createReminder.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createReminder.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(newReminder)
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
                        completion(true)
                        
                    }
                }
                dataTask.resume()
    }
    func deleteReminder(id : Int,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.deleteReminder(id: id).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.deleteReminder(id: id).method
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
                        completion(true)
                        
                    }
                }
            dataTask.resume()
    }
}
