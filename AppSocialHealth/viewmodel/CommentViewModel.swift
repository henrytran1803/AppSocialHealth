//
//  CommentViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 21/7/24.
//

import Foundation
class CommentViewModel : ObservableObject {
    @Published var comments : [Comment] = []
    func fetchAllComentByPostId(postId: Int,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        print(token)
        guard let url = API.getAllComments(postId: postId).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.getAllComments(postId: postId).method
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
                    let comments = try JSONDecoder().decode(CommentResponse.self, from: data)
                    self.comments = comments.data ?? []
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        
        dataTask.resume()
    }
    func createCommentNonePhoto(comment :CreateCommentNonePhoto,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        var newComment = comment
        newComment.user_id = id
        
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createCommentNonePhoto.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createCommentNonePhoto.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(newComment)
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
  
    func createComment(comment: CreateComment, completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        var newComment = comment
        newComment.user_id = id

        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        guard let url = API.createComment.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.createComment.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

       
        var body = Data()

        // Append body data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"body\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(newComment.body)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(newComment.user_id)\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"post_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(newComment.post_id)\r\n".data(using: .utf8)!)
        if let imageData = newComment.photo {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
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
