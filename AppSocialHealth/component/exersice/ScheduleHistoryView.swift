//
//  ScheduleHistoryView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 14/8/24.
//
import SwiftUI

struct ScheduleHistoryView: View {
    @ObservedObject var model = ScheduleHistoryViewModel()
    @State var isLoading = true
    @Binding var isOpen: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            } else {
                NavigationStack {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: { isOpen = false }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            Text("Lịch sử lịch tập")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(model.schedules, id: \.id) { schedule in
                                    NavigationLink(destination: ScheduleDetailView(schedule: schedule)) {
                                        ScheduleRowView(schedule: schedule)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .background(Color(.systemGroupedBackground))
                    }
                }
            }
        }
        .onAppear {
            model.GetAllMeal { success in
                if success {
                    isLoading = false
                }
            }
        }
    }
}

struct ScheduleRowView: View {
    var schedule: Schedule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Schedule ID: \(schedule.id)")
                .font(.headline)
            Text("Time: \(schedule.time)")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Spacer()
                Text("Calories: \(schedule.calories, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct ScheduleDetailView: View {
    @State var isLoading = true
    var schedule: Schedule
    @ObservedObject var modelExercise = ExerciseViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule Details")
                .font(.largeTitle)
                .padding(.bottom)
            
            Text("Time: \(schedule.time)")
                .font(.headline)
            
            Text("Calories: \(schedule.calories, specifier: "%.1f")")
                .font(.subheadline)
            
            if let details = schedule.detail {
                Text("Exercises:")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(details, id: \.id) { detail in
                    VStack(alignment: .leading) {
                        if let matchingEx = modelExercise.exersices.first(where: { $0.id == detail.exersice_id }) {
                            // Calculate calories based on the number of repetitions and the calories per serving
                            let calories = (Double(matchingEx.calorie) / Double(matchingEx.rep_serving)) * Double(detail.rep)

                            ExersiceItemView(
                                exersice: Exercise(
                                    id: matchingEx.id,
                                    name: matchingEx.name,
                                    description: matchingEx.description,
                                    calorie: calories, // Use the calculated calorie value
                                    rep_serving: detail.rep,
                                    time_serving: detail.time,
                                    exersice_type: matchingEx.exersice_type,
                                    photo: matchingEx.photo
                                )
                            )
                        } else {
                            Text("Exercise not found")
                        }
                    }
                    .padding(.bottom, 8)
                }

            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle(Text("Schedule Details"), displayMode: .inline)
        .onAppear {
            modelExercise.fetchAllExersice { success in
                if success {
                    isLoading = false
                }
            }
        }
    }
}
