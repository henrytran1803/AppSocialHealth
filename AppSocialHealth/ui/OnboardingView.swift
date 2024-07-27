//
//  OnboardingView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 26/7/24.
//

import Foundation
import SwiftUI
struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool
    @State private var currentPage = 0

    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
                    isFirstLaunch = true
                }, label: {
                    Text("Skip")
                })
            }
            TabView(selection: $currentPage) {
                PageView(imageName: "welcome", title: "Welcome", description: "Chào mừng bạn đến với ứng dụng của chúng tôi!")
                    .tag(0)
                PageView(imageName: "howToUse", title: "Get Started", description: "Học cách sử dụng nào, đơn giản như đan rổ!")
                    .tag(1)
                PageView(imageName: "homeView", title: "Home", description: "Vào nhà đi, pha trà đợi bạn rồi!")
                    .tag(2)
                PageView(imageName: "foodView", title: "Food management", description: "Quản lý đồ ăn ngon ơi là ngon!")
                    .tag(3)
                PageView(imageName: "listFood", title: "List food", description: "Danh sách món ngon đây, chọn đi nào!")
                    .tag(4)
                PageView(imageName: "detailFood", title: "Detail food", description: "Chi tiết món ăn, coi cho thèm chơi!")
                    .tag(5)
                PageView(imageName: "exersiceView", title: "Exercise", description: "Tập luyện thôi, đốt mỡ nào!")
                    .tag(6)
                PageView(imageName: "listExersice", title: "List exercise", description: "Danh sách bài tập, chọn cho phù hợp!")
                    .tag(7)
                PageView(imageName: "detailExersice", title: "Detail exercise", description: "Chi tiết bài tập, đọc kỹ trước khi tập!")
                    .tag(8)
                PageView(imageName: "listSchedule", title: "List schedule", description: "Danh sách lịch trình, lên kế hoạch đi!")
                    .tag(9)
                PageView(imageName: "detailSchedule", title: "Detail schedule", description: "Chi tiết lịch trình, xem cho rõ!")
                    .tag(10)
                PageView(imageName: "post", title: "Post", description: "Đăng bài đi, chia sẻ cho vui!")
                    .tag(11)
                PageView(imageName: "message", title: "Message", description: "Nhắn tin thôi, tám chuyện cả ngày!")
                    .tag(12)
                PageView(imageName: "profileView", title: "Profile", description: "Hồ sơ của bạn, cập nhật cho xịn!")
                    .tag(13)
                PageView(imageName: "Reminder", title: "Reminder", description: "Thông báo kêu đi tập như z nè!")
                    .tag(14)
                PageView(imageName: "goodJob", title: "Complete", description: "Bạn đã làm rất tốt, giỏi quá đi!")
                    .tag(15)
            }
            .tabViewStyle(PageTabViewStyle())
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Spacer()
                    Button(action: {
                        if currentPage < 15 {
                            currentPage += 1
                        } else {
                            UserDefaults.standard.setValue(true, forKey: "isFirstLaunch")
                            isFirstLaunch = true
                        }
                    }) {
                        Text(currentPage < 15 ? "Next" : "GO TO APP")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            )
        }
    }
}
struct PageView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        GeometryReader {
            geomtry in
            VStack {
                HStack{
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: geomtry.size.height * 0.7)
                        .padding()
                    Spacer()
                }
               
                
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text(description)
                    .font(.body)
                    .padding([.leading, .trailing, .bottom])
            }

        }
    }
}
