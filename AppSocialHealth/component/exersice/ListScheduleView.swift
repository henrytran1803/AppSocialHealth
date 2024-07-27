//
//  ListScheduleView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import SwiftUI

struct ListScheduleView: View {
    @ObservedObject var model : ScheduleViewModel
    @Binding var isOpen : Bool
    @State var isOpenDetail = false
    @State var searchText = ""
    @State var scheduleSelected = Schedule(id: 0, user_id: 0, time: "", calories: 0, status: 0, create_at: "")
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var showAlert = false
    var body: some View {
        GeometryReader{ geomtry in
            VStack {
                HStack{
                    HStack{
                        Button(action: {isOpen = false}, label: {Text("back")})
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black.opacity(0.2))
                            TextField("Search", text: $searchText)
                            
                        }.padding([.leading, .trailing])
                            .overlay{
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black.opacity(0.2),lineWidth: 2)
                            }
                        Button("Chọn ngày") {
                                     showAlert = true
                                 }
                                 .alert(isPresented: $showAlert) {
                                     Alert(
                                         title: Text("Chọn ngày"),
                                         message: Text("Bạn có muốn chọn một ngày?"),
                                         primaryButton: .default(Text("Chọn ngày")) {
                                             showDatePicker = true
                                         },
                                         secondaryButton: .cancel(Text("Hủy"))
                                     )
                                 }
                    }.padding([.leading, .trailing])
                    
                }
                VStack{
                    ScrollView {
                       ForEach(filteredSchedules, id: \.id) { schedule in
                           ScheduleRow(schedule: schedule)
                               .onTapGesture {
                                   scheduleSelected = schedule
                                   isOpenDetail = true
                               }
                               .padding(.vertical, 5)
                               .padding(.horizontal)
                               .background(Color.white)
                               .cornerRadius(10)
                               .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                       }
                   }
                   .padding()
                }
                .sheet(isPresented: $showDatePicker) {
                            DatePickerView(selectedDate: $selectedDate)
                        }
            }.onAppear{
                model.fetchScheduleFromdateTodate{
                    success in
                    
                }
            }
            
            .fullScreenCover(isPresented: $isOpenDetail){
                NewScheduleView(schedule: $scheduleSelected, isOpen: $isOpenDetail)
            }
        }
    }
    private var filteredSchedules: [Schedule] {
        if searchText.isEmpty {
            return model.scheduleFromDatetoDate
        } else {
            return  model.scheduleFromDatetoDate.filter {
                ($0.time.lowercased().contains(searchText.lowercased())
                 )
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
//
//#Preview {
//    ListScheduleView()
//}
struct ScheduleRow: View {
    var schedule: Schedule

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Time: \(schedule.time)")
                    .font(.headline)
                Text("Calories: \(schedule.calories, specifier: "%.2f") kcal")
                    .font(.subheadline)
                Text("Status: \(schedule.status == 1 ? "Active" : "Inactive")")
                    .font(.subheadline)
                    .foregroundColor(schedule.status == 1 ? .green : .red)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}
