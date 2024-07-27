//
//  DetailExersiceUpdateView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//
import SwiftUI

struct DetailExersiceUpdateView: View {
    
    @Binding var exersice: Exersice
    @State var isAdd = false
    @State private var inputNumber = ""
    @State var alertsuccess = false
    @State var alertfail = false
    @State var selectedDate = Date()
    @State var id: Int
    @Binding var isOpen: Bool
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerView()
                        
                        photoScrollView(geometry: geometry)
                        
                        detailInfo()
                        
                    }
                    .padding()
                }
            }
            .alert("Thêm thành công", isPresented: $alertsuccess) {
                Button("OK", role: .cancel) {}
            }
            .alert("Thêm thất bại", isPresented: $alertfail) {
                Button("OK", role: .cancel) {}
            }
            .alert("Enter a Number", isPresented: $isAdd) {
                alertContent()
            } message: {
                Text("Please enter a serving you eat")
            }
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Button(action: { isOpen = false }) {
                Text("Back")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Capsule().fill(Color.gray.opacity(0.2)))
            }
            Spacer()
            Text("Exercise Details")
            Spacer()
            Button(action: { isAdd = true }) {
                Text("Edit")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Capsule().fill(Color.gray.opacity(0.2)))
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func photoScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(exersice.photo, id: \.id) { photo in
                    if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                    }
                }
            }
            .padding()
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
    }
    
    @ViewBuilder
    private func detailInfo() -> some View {
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
    
    @ViewBuilder
    private func alertContent() -> some View {
        TextField("Number(g)", text: $inputNumber)
            .keyboardType(.numberPad)
        Button("OK") {
            if let num = Double(inputNumber) {
                handleUpdateOrDelete(num: num, isDelete: false)
            }
        }
        Button("Delete", role: .destructive) {
            handleUpdateOrDelete(num: 0, isDelete: true)
        }
        Button("Cancel", role: .cancel) {}
    }
    
    private func handleUpdateOrDelete(num: Double, isDelete: Bool) {
        if isDelete {
            ScheduleViewModel().DeleteScheduleDetail(mealDetailId: id) { success in
                alertsuccess = success
                alertfail = !success
            }
        } else {
            ScheduleViewModel().UpdateScheduleDetail(schedule: Schedule_Detail(id: id, schedule_id: 0, exersice_id: exersice.id, rep: Int(num), time: Int(num))) { success in
                alertsuccess = success
                alertfail = !success
            }
        }
    }
}
