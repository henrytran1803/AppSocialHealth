//
//  RegisterViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import Foundation
class RegisterViewModel: ObservableObject {
    @Published var register : Register = Register(email: "", firstName: "", lastName: "", role: 1, password: "")
    @Published var errorMessage: String = ""
    func register(completion: @escaping (Bool) -> Void) {
        guard let url = API.register.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = API.register.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "email": register.email,
            "fistname":register.firstName,
            "lastname":register.lastName,
            "role": 1,
            "password": register.password
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
                    let response = try JSONDecoder().decode(RegisterData.self, from: data)
                    print(response)
                    completion(true)
                } catch {
                    self.errorMessage = "Giải mã dữ liệu phản hồi thất bại: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
}
