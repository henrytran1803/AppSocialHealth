//
//  LoginViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var login : Login = Login(email: "", password: "")
    @Published var errorMessage: String = ""
    func login(completion: @escaping (Bool) -> Void) {
        guard let url = API.login.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.login.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "email": login.email,
            "password": login.password
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
                print(data)
                do {
                    let response = try JSONDecoder().decode(ResponseLogin.self, from: data)
                    print("Status: \(response.status)")
                       print("Message: \(response.message)")
                       print("ID: \(response.data.id)")
                       print("Token: \(response.data.token)")
                    UserDefaults.standard.set(response.data.token, forKey: "token")
                    UserDefaults.standard.set(response.data.id, forKey: "user_id")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.synchronize()
                    completion(true)
                } catch {
                    self.errorMessage = "Giải mã dữ liệu phản hồi thất bại: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "id_user")
        UserDefaults.standard.set(false, forKey: "isLogin")
    }
}
