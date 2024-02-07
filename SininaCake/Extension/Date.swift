//
//  Date.swift
//  SininaCake
//
//  Created by 김수비 on 1/31/24.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "a h:mm"
            dateFormatter.amSymbol = "오전"
            dateFormatter.pmSymbol = "오후"
            
        } else {
            dateFormatter.dateFormat = "yy/M/d a h:mm"
            dateFormatter.amSymbol = "오전"
            dateFormatter.pmSymbol = "오후"
        }
        
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
}
