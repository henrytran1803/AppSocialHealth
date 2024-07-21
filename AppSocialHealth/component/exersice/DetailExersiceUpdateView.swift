//
//  DetailExersiceUpdateView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import SwiftUI

struct DetailExersiceUpdateView: View {
    
        @Binding var exersice : Exersice
        @State var isAdd = false
        @State private var inputNumber = ""
        @State var alertsuccess = false
        @State var alertfail = false
        @State var selectedDate = Date()
        @State var id: Int
        @Binding var isOpen : Bool
        var body: some View {
            GeometryReader { geometry in
                ScrollView{
                    HStack{
                        Button(action: {isOpen = false}, label:  {Text("Back")})
                        Spacer()
                        Button(action: {isAdd = true}, label:  {Text("Edit")})
                    }
                    VStack (alignment: .leading){
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 10) {
                                ForEach(exersice.photo, id: \.id) { photo in
                                    if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                                    } else {
                                        ProgressView()
                                    }
                                }
                            }
                            .padding()
                        }.frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                        Text("Name: \(exersice.name)")
                        Text("Description: \(exersice.description)")
                        Text("Calorie: \(exersice.calorie)")
                        if exersice.time_serving == 0 {
                            Text("Time Serving: \(exersice.time_serving)")
                        }else {
                            Text("Rep Serving: \(exersice.rep_serving)")
                        }
                        Text("Type exersice: \(exersice.exersice_type)")
                   
                       
                    }
                }
            }.toolbar{
                Button(action: {isAdd = true}, label:  {Text("Edit")})
            }
                .alert("Thêm thành công", isPresented: $alertsuccess) {
                    Button("OK",role: .cancel){
                    }
                }
                .alert("Thêm thất bại", isPresented: $alertfail) {
                    Button("OK",role: .cancel){
                    }
                }
                .alert("Enter a Number", isPresented: $isAdd) {
                               TextField("Number(g)", text: $inputNumber)
                                   .keyboardType(.numberPad)
                               Button("OK", action: {

                                   if let num = Double(inputNumber) {
                                       ScheduleViewModel().UpdateScheduleDetail(schedule: Schedule_Detail(id: id, schedule_id: 0 , exersice_id: exersice.id, rep: Int(num), time: Int(num))){success in
                                               if success {
                                                   alertsuccess = true
                                               }else {
                                                   alertfail = true
                                               }
                                           }
                                   }
                               })
                    Button("Delete", role: .destructive, action: {
                        ScheduleViewModel().DeleteScheduleDetail(mealDetailId: id){
                            success in
                                if success {
                                    alertsuccess = true
                                }else {
                                    alertfail = true
                                }
                        }
                                })
                    
                               Button("Cancel", role: .cancel, action: {
                                   
                               })
                           } message: {
                               Text("Please enter a serving you eat")
                           }
        }
    }
