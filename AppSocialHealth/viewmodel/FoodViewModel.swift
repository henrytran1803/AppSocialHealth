//
//  FoodViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import Foundation
class FoodViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    func fetchAllFood(completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        print(token)
        guard let url = API.getListFood.asURLRequest().url else {
            print("URL không hợp lệ")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = API.getListFood.method
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
                    let foodResponse = try JSONDecoder().decode(FoodResponseData.self, from: data)
                    self.foods = foodResponse.data
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
