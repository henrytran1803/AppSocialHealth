//
//  NewScheduleView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import SwiftUI

struct NewScheduleView: View {
    @ObservedObject var model = ExerciseViewModel()
    @Binding var schedule: Schedule
    @Binding var isOpen : Bool
    @State var isAdd : Bool = false
    @State var searchText = ""
    @State var exersiceSelected = Exercise(id: 0, name: "", description: "", calorie: 0, rep_serving: 0, time_serving: 0, exersice_type: ExersiceType(id: 0, name: ""), photo: [])
    @State var id = 0
    @State var isOpenDetail = false
    @State private var reminderDate = Date()
    @State private var showReminderPicker = false
    var body: some View {
        GeometryReader{ geomtry in
            NavigationStack{
            HStack{
                Button(action: {isOpen = false}, label: {Text("back")})
                Spacer()
                Button(action: {isAdd = true}, label: {Text("Add")})
            }.padding([.leading, .trailing])
                ScrollView {
                    if let details = schedule.detail {
                        if details.isEmpty {
                            HStack{
                                Spacer()
                                Text("It's empty")
                                Spacer()
                            }
                        } else {
                            ForEach(details, id: \.id) { detail in
                                if let matchingEx = model.exersices.first(where: { $0.id == detail.exersice_id }) {
                                    
                                        ExersiceItemView(exersice: Exercise(id: matchingEx.id, name: matchingEx.name, description: matchingEx.description, calorie: matchingEx.calorie, rep_serving: detail.rep, time_serving: detail.time, exersice_type: matchingEx.exersice_type, photo: matchingEx.photo))
                                            .onTapGesture {
                                        exersiceSelected = matchingEx
                                        id = detail.id
                                        isOpenDetail = true
                                    }
                                } else {
                                    Text("Food not found")
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
                Button(action: {
                    showReminderPicker.toggle()
                }) {
                    Text("Set Reminder")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showReminderPicker) {
                    VStack {
                        DatePicker("Select reminder time", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(WheelDatePickerStyle())
                        
                        Button("Set Reminder") {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let formattedDate = dateFormatter.string(from: reminderDate)
                            print(formattedDate)
                            let reminder = ReminderCreate(
                                user_id: 0,
                                description: "Exercise Reminder",
                                schedule_id: 10,
                                meal_id: nil,
                                reminder_type_id: 1,
                                date: formattedDate
                            )
                            
                            let reminderModel = ReminderModelView()
                            reminderModel.createReminder(reminder: reminder) { success in
                                if success {
                                    print("Reminder set successfully")
                                } else {
                                    print("Failed to set reminder")
                                }
                                showReminderPicker = false
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                .fullScreenCover(isPresented: $isOpenDetail){
                    DetailExersiceUpdateView(exersice: $exersiceSelected, id: id, isOpen : $isOpenDetail)
                }
                .fullScreenCover(isPresented: $isAdd){
                    ExersiceListCreateView(id: $schedule.id, isOpen: $isAdd, modelEx: model)
                }
            }.onAppear{
                model.fetchAllExersice{
                    success in
                    
                }
            }
            
        }
    }
}
