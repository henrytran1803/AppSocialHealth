//
//  LoginViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation
class LoginViewModel: ObservableObject {
    @Published var login: Login = Login(email: "", password: "")
    @Published var errorMessage: String = ""
    @Published var isLogin: Bool = UserDefaults.standard.bool(forKey: "isLogin")
    @Published var isFirstTime: Bool = UserDefaults.standard.bool(forKey: "isFirstTime")

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
                    completion(false)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode), let data = data else {
                    self.errorMessage = "Phản hồi không thành công từ server (mã trạng thái: \(httpResponse.statusCode))"
                    completion(false)
                    return
                }
                do {
                    let response = try JSONDecoder().decode(ResponseLogin.self, from: data)
                    UserDefaults.standard.set(response.data.token, forKey: "token")
                    UserDefaults.standard.set(response.data.id, forKey: "user_id")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.synchronize()
                    self.isLogin = true
                    completion(true)
                } catch {
                    self.errorMessage = "Giải mã dữ liệu phản hồi thất bại: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }

    func checkToken(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let url = API.getUser(id: id).asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = API.getUser(id: id).method
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
                    self.logout()
                    self.isLogin = false
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        dataTask.resume()
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.setValue(false, forKey: "isFirstLaunch")

        isLogin = false
    }
}
