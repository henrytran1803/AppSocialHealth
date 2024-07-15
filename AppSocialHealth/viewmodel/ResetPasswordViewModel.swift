//
//  ResetPasswordViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation
class ResetPasswordViewModel: ObservableObject {
    @Published var resetPass : ResetPassword = ResetPassword(token: "", new_password: "")
    @Published var errorMessage: String = ""
    
    
    func requestResetPass(email: String, completion: @escaping (Bool) -> Void) {
        guard let url = API.requestPasswordReset.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.requestPasswordReset.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "email": email,
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Lỗi khi chuyển đổi dữ liệu sang JSON: \(error.localizedDescription)")
            completion(false)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Lỗi khi gọi API: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Phản hồi không hợp lệ từ server"
                    print("1")
                    completion(false)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode), let data = data else {
                    self.errorMessage = "Phản hồi không thành công từ server (mã trạng thái: \(httpResponse.statusCode))"
                    completion(false)
                    print("2")
                    return
                }
                
                
                completion(true)
//                do {
//                    let response = try JSONDecoder().decode(ResponseLogin.self, from: data)
//
//                    completion(true)
//                } catch {
//                    self.errorMessage = "Giải mã dữ liệu phản hồi thất bại: \(error.localizedDescription)"
//                    completion(false)
//                }
            }
        }
        dataTask.resume()
    }
    
    func resetPass(completion: @escaping (Bool) -> Void) {
        guard let url = API.confirmPasswordReset.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.confirmPasswordReset.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "token": resetPass.token,
            "new_password": resetPass.new_password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Lỗi khi chuyển đổi dữ liệu sang JSON: \(error.localizedDescription)")
            completion(false)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Lỗi khi gọi API: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Phản hồi không hợp lệ từ server"
                    print("1")
                    completion(false)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode), let data = data else {
                    self.errorMessage = "Phản hồi không thành công từ server (mã trạng thái: \(httpResponse.statusCode))"
                    completion(false)
                    print("2")
                    return
                }
                completion(true)
//                do {
//                    let response = try JSONDecoder().decode(ResponseLogin.self, from: data)
//                  
//                    completion(true)
//                } catch {
//                    self.errorMessage = "Giải mã dữ liệu phản hồi thất bại: \(error.localizedDescription)"
//                    completion(false)
//                }
            }
        }
        dataTask.resume()
    }
    
    
}
