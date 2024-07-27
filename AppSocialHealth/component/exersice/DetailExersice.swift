//
//  DetailExersice.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//
import SwiftUI

struct DetailExersice: View {
    @State var exersice: Exersice
    @State var isAdd = false
    @State private var inputNumber = ""
    @State var alertsuccess = false
    @State var alertfail = false
    @State var selectedDate = Date()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    photoScrollView(geometry: geometry)
                    
                    Group {
                        Text("Name: \(exersice.name)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Description: \(exersice.description)")
                            .font(.body)
                        
                        Text("Calorie: \(exersice.calorie, specifier: "%.2f")")
                            .font(.body)
                        
                        if exersice.time_serving == 0 {
                            Text("Time Serving: \(exersice.time_serving)")
                                .font(.body)
                        } else {
                            Text("Rep Serving: \(exersice.rep_serving)")
                                .font(.body)
                        }
                        
                        Text("Type Exercise: \(exersice.exersice_type)")
                            .font(.body)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle(exersice.name)
            .toolbar {
                Button(action: {
                    isAdd = true
                }) {
                    Text("ADD")
                }
            }
            .alert("Thêm thành công", isPresented: $alertsuccess) {
                Button("OK", role: .cancel) {}
            }
            .alert("Thêm thất bại", isPresented: $alertfail) {
                Button("OK", role: .cancel) {}
            }
            .alert("Enter a Number", isPresented: $isAdd) {
                TextField("Number(g)", text: $inputNumber)
                    .keyboardType(.numberPad)
                Button("OK") {
                    if let num = Double(inputNumber) {
                        handleAddButton(num: num)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enter a serving you eat")
            }
        }
    }
    
    @ViewBuilder
    private func photoScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(exersice.photo, id: \.id) { photo in
                    if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        ProgressView()
                    }
                }
            }
            .padding()
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
    }
    
    private func handleAddButton(num: Double) {
        let isMealEmpty = UserDefaults.standard.bool(forKey: "scheduleEmpty")
        if isMealEmpty {
            ScheduleViewModel().CreateSchedule(schedule: ScheduleCreateFull(user_id: 0, time: getCurrentDateFullString(), detail:[ScheduleDetailCreateSigle(exersice_id: exersice.id, rep: Int(num), time: Int(num))])) { success in
                alertsuccess = success
                alertfail = !success
            }
        } else {
            let idSchedule = UserDefaults.standard.integer(forKey: "scheduleId")
            ScheduleViewModel().CreateScheduleDetail(schedule: ScheduleDetailCreate(schedule_id: idSchedule, exersice_id: exersice.id, rep: Int(num), time: Int(num))) { success in
                alertsuccess = success
                alertfail = !success
            }
        }
    }
}
