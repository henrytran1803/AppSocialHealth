//
//  DetailExersiceCreateView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 23/7/24.
//
import SwiftUI

struct DetailExersiceCreateView: View {
    @State var id: Int
    @State var exersice: Exercise
    @State var isAdd = false
    @State private var inputNumber = ""
    @State var alertsuccess = false
    @State var alertfail = false
    @State var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        photoScrollView(geometry: geometry)
                        
                        detailInfo()
                        
                        Spacer()
                        
                        Button(action: { isAdd = true }) {
                            Text("ADD")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                .navigationTitle(exersice.name)
                .navigationBarTitleDisplayMode(.inline)
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
    private func photoScrollView(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(exersice.photo, id: \.id) { photo in
                    if let imageData = photo.image, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else {
                        ProgressView()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
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
            Text("Rep Serving: \(exersice.rep_serving)")
                .font(.body)
            
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
                ScheduleViewModel().CreateScheduleDetail(schedule: ScheduleDetailCreate(schedule_id: id, exersice_id: exersice.id, rep: Int(num), time: Int(num))) { success in
                    alertsuccess = success
                    alertfail = !success
                }
            }
        }
        Button("Cancel", role: .cancel) {}
    }
}
