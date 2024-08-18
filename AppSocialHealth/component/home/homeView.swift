//
//  homeView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 15/7/24.
//

import SwiftUI
import Charts
import TipKit
struct homeView: View {
    @State var modelUser = UserViewModel()
    @State var modelInfo = InfomationViewModel()
    @State var isLoading = true
    @StateObject private var tipViewModel = TipViewModel()
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            } else {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Chào mừng quay trở lại, \(modelUser.user.firstname)!")
                                .bold()
                                .font(.title2)
                            Spacer()
                        }
                        .padding([.leading, .trailing])
                        UserProfileView(user: modelUser.user)
                            .padding()
                        
                        
                        VStack{
                            ProcressHomeView(calorie: $modelUser.user.calorie, info: $modelInfo.info, totalOrther: $modelInfo.info.nutrition.total_calorie)
                                .frame(height: geometry.size.height * 0.4)
                                .padding()
                            TipView( CustomTip(titleText: "Biểu đồ", messageText: "Đây là biểu đồ của ngày hôm nay", iconName: "scribble"), arrowEdge: .top)

                        }
                        VStack{
                            TipView( CustomTip(titleText: "Tổng kết", messageText: "Bảng này có tất cả các thông số của bạn", iconName: "scribble"), arrowEdge: .bottom)
                           
                            SummaryView(
                                carb: modelInfo.info.nutrition.total_carb,
                                fat: modelInfo.info.nutrition.total_fat,
                                sugar: modelInfo.info.nutrition.total_sugar,
                                protein: modelInfo.info.nutrition.total_protein,
                                totalCalories: modelInfo.info.nutrition.total_calorie,
                                calorieDeficit: modelUser.user.calorie - modelInfo.info.nutrition.total_calorie
                            )
                            
                            .padding()
                        }
                        // Add more sections here as needed
                    }
                }
            }
        }
        .onAppear {
            modelInfo.fetchInfoBydate { success in
                if success {
                    modelUser.fetchUser { success in
                        if success {
                            isLoading = false
                        }
                    }
                }
            }
        }
    }
}

struct UserProfileView: View {
    let user: User
    
    var body: some View {
        HStack {
            if let uiImage = UIImage(data: user.photo?.image ?? Data()) {
                CircleImage(uiImage: uiImage)
                    .frame(width: 60, height: 60)
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 60, height: 0)
            }
            
            VStack(alignment: .leading) {
                Text("\(user.firstname) \(user.lastname)")
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

struct ProcressHomeView: View {
    @Binding var calorie: Double
    @Binding var info: GetInfomationDate
    @State var total: Double = 0
    @Binding var totalOrther: Double
    var body: some View {
        VStack {
            HStack {
                let total = info.nutrition.total_carb + info.nutrition.total_fat + info.nutrition.total_protein + info.nutrition.total_sugar

                if total > 0 {
                    NutritionProgressView(progress: info.nutrition.total_carb / total, color: .green, label: "Carb", value: info.nutrition.total_carb)
                    NutritionProgressView(progress: info.nutrition.total_fat / total, color: .red, label: "Fat", value: info.nutrition.total_fat)
                    NutritionProgressView(progress: info.nutrition.total_protein / total, color: .blue, label: "Protein", value: info.nutrition.total_protein)
                    NutritionProgressView(progress: info.nutrition.total_sugar / total, color: .yellow, label: "Sugar", value: info.nutrition.total_sugar)
                } else {
                    Text("No nutritional information available")
                        .foregroundColor(.secondary)
                }
               
            }
            if totalOrther / calorie < 0.5 {
                ProgressBar(progress: .constant(totalOrther / calorie), color: .yellow)
                    .frame(width: 200, height: 200)
                    .padding(40.0)
            } else if totalOrther / calorie > 1 {
                ProgressBar(progress: .constant(1 - totalOrther / calorie), color: .red)
                    .frame(width: 200, height: 200)
                    .padding(40.0)
            } else {
                ProgressBar(progress: .constant(totalOrther / calorie), color: .green)
                    .frame(width: 200, height: 200)
                    .padding(40.0)
            }
        }
        .onAppear {
            total = info.nutrition.total_carb + info.nutrition.total_sugar + info.nutrition.total_protein + info.nutrition.total_fat
        }
    }
}


struct SummaryView: View {
    let carb: Double
    let fat: Double
    let sugar: Double
    let protein: Double
    let totalCalories: Double
    let calorieDeficit: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tổng kết")
                .font(.headline)
                .foregroundColor(.red)
                .underline()
                .padding(.bottom, 5)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Carb: \(String(format: "%.2f", carb)) g")
                    Text("Sugar: \(String(format: "%.2f", sugar)) g")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Fat: \(String(format: "%.2f", fat)) g")
                    Text("Protein: \(String(format: "%.2f", protein)) g")
                }
            }
            
            Text("Tổng calories: \(String(format: "%.2f", totalCalories)) calo")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 5)
            
            if calorieDeficit > 0 {
                Text("*Còn thiếu so với bạn \(String(format: "%.2f", calorieDeficit)) calo")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.leading, .trailing, .top])
    }
}
