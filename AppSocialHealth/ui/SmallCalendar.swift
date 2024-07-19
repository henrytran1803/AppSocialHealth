//
//  SmallCalendar.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 18/7/24.
//

import SwiftUI

struct SmallCalendarView: View {
    let daysInMonth: [Date]
    let markedDates: [Date]

    var body: some View {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let dates = range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
        VStack(alignment: .center){
            Text("Lịch")
                .bold()
            Divider()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(dates, id: \.self) { date in
                    VStack {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(width: 30, height: 30)
                            .background(isToday(date: date) ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(15)
                        
                        if markedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
        }
    }

    private func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}
