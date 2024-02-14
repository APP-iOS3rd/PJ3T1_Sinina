//
//  CalendarViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

/**
 날짜 칸 표시를 위한 일자 정보
 */
struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
    var isNotCurrentMonth: Bool = false
    var isSelected: Bool = false
    
    var isSecondSelected = false

        mutating func selectedToggle() {
            if isSelected {
                isSelected = false
                isSecondSelected = true
            } else if isSecondSelected {
                isSecondSelected = false
            } else {
                isSelected = true
            }
        }
}





/**
 일정 정보
 */
struct Schedule: Decodable {
    var name: String
    var startDate: Date
    var endDate: Date
    
    /**
     일정 표시 색깔 지정
     */
    var color = Color(.white)
    
    enum CodingKeys: String, CodingKey {
        case name, startDate, endDate
    }
}


extension Date {
    /**
     년도
     */
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /**
     월
     */
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /**
     일
     */
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /**
     요일
     */
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /**
     이 날짜가 포함된 월의 모든 일자의 Date
     */
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        //getting start Date...
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    /**
     이 날짜가 포함된 월의 마지막 일
     */
    func getLastDayInMonth() -> Int {
        let calendar = Calendar.current
        
        return (calendar.range(of: .day, in: .month, for: self)?.endIndex ?? 0) - 1
    }
    
    /**
     이 날짜가 포함된 월의 첫 일
     */
    func getFirstDayInMonth() -> Int {
        let calendar = Calendar.current
        
        return (calendar.range(of: .day, in: .month, for: self)?.startIndex ?? 0)
    }
    
    /**
     시간 값을 제외한 Date 리턴
     */
    func withoutTime() -> Date {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day)
        
        return Calendar.current.date(from: dateComponents) ?? self
    }
    
    
}


