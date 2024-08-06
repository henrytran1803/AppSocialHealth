//
//  MessageViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 22/7/24.
//

import Foundation
class MessageViewModel : ObservableObject {
    @Published var message : MessageConvertion = MessageConvertion(users: [], messages: [])
    @Published  var convertion = Convertion(id: 0, created_at: "", participants: [], users: [])
    func fetchAllMessageConvertionByuser(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
        guard let url = API.listConversationMessages(conversationId: convertion.id).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.listConversationMessages(conversationId: convertion.id).method
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
                            let message = try JSONDecoder().decode(MessageConvertion.self, from: data)
                            self.message = message
                            completion(true)
                        } catch {
                            print("Failed to decode JSON: \(error.localizedDescription)")
                            completion(false)
                        }
                    }
                }
                dataTask.resume()
            }
    func sendMessage(message: SendMessage,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
        guard let url = API.sendMessage.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.sendMessage.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(message)
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
    
}
