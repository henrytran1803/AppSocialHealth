//
//  ScheduleViewModel.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import Foundation


class ScheduleViewModel: ObservableObject {
    @Published var scheduleFromDatetoDate : [Schedule] = []
    @Published var scheduleToday = Schedule(id: 0, user_id: 0, time: "", calories: 0, status: 0, create_at: "", detail: [])
    func fetchScheduleByIdAndDate(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.getScheduleByidAndDate(id: id, date: getCurrentDateString()).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.getScheduleByidAndDate(id: id, date: getCurrentDateString()).method
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
                            if let rawDataString = String(data: data, encoding: .utf8) {
                                           print("Raw Data: \(rawDataString)")
                                       } else {
                                           print("Unable to convert raw data to string")
                                       }
                            let schedule = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                            self.scheduleToday = schedule.data ?? Schedule(id: 0, user_id: 0, time: "", calories: 0, status: 0, create_at: "", detail: [])
                            print( self.scheduleToday)
                            if self.scheduleToday.id == 0  {
                                UserDefaults.standard.setValue(true, forKey: "scheduleEmpty")
                                UserDefaults.standard.setValue(self.scheduleToday.id, forKey: "scheduleId")
                            }else {
                                UserDefaults.standard.setValue(false, forKey: "scheduleEmpty")
                                UserDefaults.standard.setValue(self.scheduleToday.id, forKey: "scheduleId")
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
    func fetchScheduleFromdateTodate(completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token không hợp lệ")
            completion(false)
            return
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let endOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
        
        let fromDate = dateFormatter.string(from: startOfMonth)
        let toDate = dateFormatter.string(from: endOfMonth)
        print(fromDate)
        print(toDate)
        guard let url = API.getScheduleFromDateToDate(id: id,fromDate: fromDate, date: toDate).asURLRequest().url else {
                print("URL không hợp lệ")
                completion(false)
                return
            }
        var request = URLRequest(url: url)
        request.httpMethod = API.getScheduleFromDateToDate(id:id,fromDate: fromDate, date: toDate).method
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
                    let schedule = try JSONDecoder().decode(ScheduleFromDateToDate.self, from: data)
                    self.scheduleFromDatetoDate = schedule.data ?? []
                    print(schedule)
                    completion(true)
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }
    
    func CreateSchedule(schedule : ScheduleCreateFull,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        var newSchedule = schedule
        newSchedule.user_id = id
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createSchedule.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createSchedule.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(newSchedule)
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
                            let meal = try JSONDecoder().decode(ScheduleCreateResponse.self, from: data)
                            UserDefaults.standard.setValue(meal.id, forKey: "scheduleId")
                                UserDefaults.standard.setValue(false, forKey: "scheduleEmpty")
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
    func CreateScheduleDetail(schedule : ScheduleDetailCreate,completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.createScheduleDetail.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.createScheduleDetail.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(schedule)
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
    func UpdateSchedule(schedule : ScheduleUpdate,completion: @escaping (Bool) -> Void) {
//        let id = UserDefaults.standard.integer(forKey: "user_id")
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
        guard let url = API.updateSchedule.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.updateSchedule.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(schedule)
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
//                        guard let data = data else {
//                            print("No data received from server")
//                            completion(false)
//                            return
//                        }
                        completion(true)
//                        do {
//                            let meal = try JSONDecoder().decode(ScheduleCreateResponse.self, from: data)
//                            UserDefaults.standard.setValue(meal.id, forKey: "scheduleId")
//                                UserDefaults.standard.setValue(false, forKey: "scheduleEmpty")
//                            print(meal)
//                            completion(true)
//                        } catch {
//                            print("Failed to decode JSON: \(error.localizedDescription)")
//                            completion(false)
//                        }
                    }
                }
                dataTask.resume()
    }
    func UpdateScheduleDetail(schedule : Schedule_Detail,completion: @escaping (Bool) -> Void) {
//        let id = UserDefaults.standard.integer(forKey: "user_id")
        let scheduleid = UserDefaults.standard.integer(forKey: "scheduleId")
        var newschedule = schedule
        newschedule.schedule_id = scheduleid
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
        guard let url = API.updateScheduleDetail.asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.updateScheduleDetail.method
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                do {
                    let jsonData = try JSONEncoder().encode(newschedule)
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
//                        guard let data = data else {
//                            print("No data received from server")
//                            completion(false)
//                            return
//                        }
                        completion(true)
//                        do {
//                            let meal = try JSONDecoder().decode(ScheduleCreateResponse.self, from: data)
//                            UserDefaults.standard.setValue(meal.id, forKey: "scheduleId")
//                                UserDefaults.standard.setValue(false, forKey: "scheduleEmpty")
//                            print(meal)
//                            completion(true)
//                        } catch {
//                            print("Failed to decode JSON: \(error.localizedDescription)")
//                            completion(false)
//                        }
                    }
                }
                dataTask.resume()
    }
    func DeleteScheduleDetail(mealDetailId: Int,completion: @escaping (Bool) -> Void) {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
                    print("Token không hợp lệ")
                    completion(false)
                    return
                }
                guard let url = API.deleteScheduleDetail(detailId: mealDetailId).asURLRequest().url else {
                    print("URL không hợp lệ")
                    completion(false)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = API.deleteScheduleDetail(detailId: mealDetailId).method
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
//                        guard let data = data else {
//                            print("No data received from server")
//                            completion(false)
//                            return
//                        }
                        completion(true)
                    }
                }
                dataTask.resume()
        
    }
    
}
