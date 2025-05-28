//
//  CalenderView.swift
//  Ayoss
//
//  Created by 어재선 on 5/24/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var month: Date = Date()
    @State private var clickedCurrentMonthDates: Date?
    
    init(
        month: Date = Date(),
        clickedCurrentMonthDates: Date? = nil
    ) {
        _month = State(initialValue: month)
        _clickedCurrentMonthDates = State(initialValue: clickedCurrentMonthDates)
    }
    
    var body: some View{
        VStack {
            
            // TODO: headerView
            headerView
                
            // TODO: calendarGridView
            
        }
    }
    

    // MARK: - HeaderView
    private var headerView: some View {
        VStack {
            HStack{
                // TODO: yearMonthView
                
                Spacer()
                
                Button(
                    action: {
                        
                    },
                    label: {
                        Image(systemName: "list.bullet")
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                )
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
            HStack {
                ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
                    Text(Self.weekdaySymbols[symbol].uppercased())
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            .padding(.bottom, 5)
        }
    }
    // MARK: - YearMonthView
    private var yearMonthView: some View {
        HStack(alignment: .center, spacing: 20) {
            Button(
                action: {
                    
                },
                label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                    // TODO: canMoveTopreviousMonth() 추가 할 것
                        .foregroundStyle(.black)
                    
                }
            )
            // .disabled(!canMoveToPreviousMonth())
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.title.bold())
            
            Button(
                action: {
                    // changeMonth(by: 1)
                },
                label: {
                    Image(systemName: "chevron.right")
                        .font(.title)
                    // TODO: canMoveTopreviousMonth() 추가 할 것
                        .foregroundStyle(.black)
                }
            )
            // .disabled(!canMoveToPreviousMonth())
        }
    }
    // MARK: - CalendarGridView
//    private var calendarGridView: some View {
//        let daysInMonth: Int = numberOfDays
//    }
}


//MARK: - Extenstion CalenderView logic
private extension CalendarView {
    // 특정 해당 날짜
    func getDate(for index: Int) -> Date {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(
            from: DateComponents(
            year: calendar.component(.year, from: month),
            month: calendar.component(.month, from: month),
            day: 1)
        ) else {
            return Date()
        }
        var dateComponents = DateComponents()
        
        dateComponents.day = index
        
        let timeZone = TimeZone.current
        let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
        dateComponents.second = Int(offset)
        
        let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
        return date
    }
    
    // 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    // 이전 월 마지막 일자
    func previousMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
        
        return previousMonth
        
    }
    // 월 변경
    func changeMonth(by value: Int) {
        self.month = adjustedMonth(by: value)
    }
    
    // 이전 월로 이동 가능한지 확인
    func canMoveToPreviousMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate =  calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
        
        if adjustedMonth(by: -1) < targetDate {
            return false
        }
        return true
    }
    
    // 다음 월로 이동 가한지 확인
    func canMoveToNextMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
        
        if adjustedMonth(by: 1) > targetDate {
            return false
        }
        return true
    }
    
    // 변경하려는 월 반환
    func adjustedMonth(by value: Int) -> Date {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            return newMonth
        }
        return month
    }
}

// MARK: - extenstion CalenderView
private extension CalendarView {
    var today: Date {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }
    
    static var calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }()
    
    static var weekdaySymbols: [String] = Calendar.current.weekdaySymbols
    
}
#Preview {
    CalendarView()
}
