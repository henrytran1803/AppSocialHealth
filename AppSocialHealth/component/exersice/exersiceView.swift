//
//  exersiceView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct exersiceView: View {
    @State  var isLoading  = true
    @State var searchText = ""
    @State private var selected = ""
    @State var healthKitManager = HealthKitManager()
    @State var stepCount = 0
    let list = ["Add Ex", "New Sche"]
    @ObservedObject var model = ScheduleViewModel()
    @ObservedObject var modelExersice = ExerciseViewModel()
    @State var exersiceSelected = Exercise(id: 0, name: "", description: "", calorie: 0, rep_serving: 0, time_serving: 0, exersice_type: ExersiceType(id: 0, name: ""), photo: [])
    @State var id = 0
    @State var isOpenDetail = false
    @State var isOpen = false
    @State var isAddNewSchedule = false
    @ObservedObject var modelUser = UserViewModel()
    @ObservedObject var modelInfo = InfomationViewModel()
    @State var isReload = false
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            }else {
                ZStack{
                  

                    ScrollView{
                        VStack {
                            HStack{
                                Text("Lịch tập hôm nay")
                                    .bold()
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black.opacity(0.2))
                                    TextField("Search", text: $searchText)
                                    
                                }.padding([.leading, .trailing])
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.black.opacity(0.2),lineWidth: 2)
                                    }
                            }.padding([.leading, .trailing])
                            
                            
                            let markedDates = uniqueDates(from: model.scheduleFromDatetoDate)
                            let nearestFutureDate = getNearestFutureDate(from: markedDates)
                            VStack {
                                ScrollView {
                                    if let details = model.scheduleToday.detail {
                                        if details.isEmpty {
                                            HStack{
                                                Spacer()
                                                Text("It's empty")
                                                Spacer()
                                            }
                                        } else {
                                            ForEach(details, id: \.id) { detail in
                                                if let matchingEx = modelExersice.exersices.first(where: { $0.id == detail.exersice_id }) {
                                                    
//                                                    Text("\(matchingEx.time)\(matchingEx.time)")
                                                    ExersiceItemView(exersice: Exercise(id: matchingEx.id, name: matchingEx.name, description: matchingEx.description, calorie: matchingEx.calorie, rep_serving: detail.rep, time_serving: detail.time, exersice_type: matchingEx.exersice_type, photo: matchingEx.photo))
                                                       .onTapGesture {
                                                           exersiceSelected = matchingEx
                                                           id = detail.id
                                                           isOpenDetail = true
                                                       }
                                                   } else {
                                                       Text("Ex not found")
                                                   }
                                            }
                                        }
                                    } else {
                                        HStack{
                                            Spacer()
                                            Text("It's empty")
                                            Spacer()
                                        }
                                    }
                                }
                            }.frame(height: geometry.size.height * 0.5)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black.opacity(0.3),lineWidth: 3)
                                }
                            
                            
                            
                            
                            StatisticsView(stepCount: $stepCount, user: $modelUser.user, scheduleCalories: .constant(modelInfo.info.schedule))

                            // lịch
                            HStack{
                                SmallCalendarView(daysInMonth: [], markedDates: markedDates)
                                    .frame(width: geometry.size.width * 0.63, height: geometry.size.height * 0.4)
                                    .background(.white)
                                VStack{
                                    Text("Lịch tập gần nhất")
                                        .font(.system(size: 20))
                                    Text("Ngày: \(nearestFutureDate)")
                                }
                                
                            }
                        }
                    }
                    VStack{
                        Spacer()
                        HStack {
                            Spacer()
                            FloatingPickerView(selected: $selected, list: list)
                        }
                    }
                    .onChange(of: selected) { newValue in
                        if newValue == "Add Ex" {
                            isOpen = true
                        } else if newValue == "New Sche"{
                            isAddNewSchedule = true
                        }
                    }
                }
               
                
            .fullScreenCover(isPresented: $isOpen){
                ExersiceListView(isOpen: $isOpen, modelEx: modelExersice)
                
            } .onChange(of: isOpen) { newValue in
//                if !newValue {
//                    print("Detail view closed")
//                    isLoading = true
//                    model.scheduleToday = Schedule(id: 0, user_id: 0, time: "", calories: 0, status: 0, create_at: "", detail: [])
//                    model.fetchScheduleByIdAndDate { success in
//                        if success {
//                            isLoading = false
//                        }
//                    }
//                }
                        isReload.toggle()
                
            }
            .fullScreenCover(isPresented: $isOpenDetail) {
                DetailExersiceUpdateView(exersice: $exersiceSelected, id: id, isOpen: $isOpenDetail)
            }
            .onChange(of: isOpenDetail) { newValue in
//                if !newValue {
//                    isLoading = true
//                    model.scheduleToday = Schedule(id: 0, user_id: 0, time: "", calories: 0, status: 0, create_at: "", detail: [])
//                    model.fetchScheduleByIdAndDate { success in
//                        if success {
//                            isLoading = false
//                        }
//                    }
                isReload.toggle()
            }
            .fullScreenCover(isPresented: $isAddNewSchedule){
                ListScheduleView(model: model, isOpen: $isAddNewSchedule)
            }
                
            }
        } .onAppear{
            model.fetchScheduleFromdateTodate{
                success in
                if success {
                    model.fetchScheduleByIdAndDate{
                        success in
                        if success {
                            modelExersice.fetchAllExersice{
                                success in
                                if success {
                                    isLoading = false
                                    healthKitManager.requestAuthorization { (success, error) in
                                        if success {
                                            healthKitManager.fetchStepCount { (count, error) in
                                                if let count = count {
                                                    DispatchQueue.main.async {
                                                        self.stepCount = Int(count)
                                                    }
                                                } else if let error = error {
                                                    print("Error fetching step count: \(error.localizedDescription)")
                                                }
                                            }
                                        } else if let error = error {
                                            print("Authorization failed: \(error.localizedDescription)")
                                        }
                                    }
                                    modelUser.fetchUser{
                                        successs in
                                    }
                                    modelInfo.fetchInfoBydate{
                                        
                                        success in
                                        if success {
                                            
                                        }else {
                                            print("4")
                                        }
                                    }
                                    
                                }else {
                                    print("3")
                                }
                            }
                        }else {
                            print("2")
                        }
                    }
                }else {
                    print("1")
                }
            }
        }
        .id(isReload)
    }
    
    func calculateCalories(from steps: Double, weight: Double) -> Double {
            return 3.5 * weight * (steps / 600)
        }
}

func convertToDate(from dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return dateFormatter.date(from: dateString)
}
func uniqueDates(from schedules: [Schedule]) -> [Date] {
    var uniqueDatesSet = Set<Date>()
    
    for schedule in schedules {
        if let date = convertToDate(from: schedule.time ?? "") {
            let startOfDay = Calendar.current.startOfDay(for: date)
            uniqueDatesSet.insert(startOfDay)
        }
    }
    
    return Array(uniqueDatesSet).sorted()
}
func getNearestFutureDate(from dates: [Date]) -> Date? {
    let currentDate = Date()
    let futureDates = dates.filter { $0 > currentDate }
    return futureDates.sorted().first
}
struct StatisticsView: View {
    @Binding var stepCount: Int
    @Binding var user: User
    @Binding var scheduleCalories: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Thống kê")
                .font(.title2)
                .bold()
                .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
                Text("Số bước chân: \(stepCount)")
            }
            .font(.body)
            .padding(.vertical, 5)
            
            let calorieStep = calculateCalories(from: Double(stepCount), weight: user.weight)
            HStack {
                Image(systemName: "flame")
                    .foregroundColor(.red)
                Text("Calorie từ bước chân: \(String(format: "%.2f", calorieStep)) cal")
            }
            .font(.body)
            .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.blue)
                Text("Tổng số calorie từ bài tập: \(String(format: "%.2f", scheduleCalories)) cal")
            }
            .font(.body)
            .padding(.vertical, 5)
            
            HStack {
                Image(systemName: "sum")
                    .foregroundColor(.orange)
                Text("Tổng tất cả: \(String(format: "%.2f", scheduleCalories + calorieStep)) cal")
            }
            .font(.body)
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.leading, .trailing, .top])
    }
    
    func calculateCalories(from steps: Double, weight: Double) -> Double {
        // Your calorie calculation logic based on steps and weight
        return steps * 0.05 * weight
    }
}
