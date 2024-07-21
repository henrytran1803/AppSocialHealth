//
//  LikeModelView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import Foundation
class LikeModelView : ObservableObject {
    @Published var isLike : Bool = false
    func CreateLikes(post_id: Int,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")

        var like = CreateLike(user_id: id, post_id: post_id)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.likePost.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.likePost.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(like)
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

    func DelteLike(post_id: Int,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")

        var like = CreateLike(user_id: id, post_id: post_id)
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.deleteLike.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.deleteLike.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(like)
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
    func CheckIsLike(post_id: Int,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.checkIsLikeUserIdAndPostId(id: id, post: post_id).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
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
                            let meal = try JSONDecoder().decode(LikeResponse.self, from: data)
                            print("is here")
                            self.isLike = meal.data
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
