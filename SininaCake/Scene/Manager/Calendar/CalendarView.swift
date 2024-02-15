//
//  CalendarView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//
import SwiftUI
struct CalendarView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    
    var dateString: String? {
        let date =  Date()                     // 넣을 데이터(현재 시간)
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MM-dd"  // 변환할 형식
        let dateString = myFormatter.string(from: date)
        return dateString
    }
    


//    var testSchedule: Schedule { Schedule(name: "이벤트 기간 \(dateString ?? "") ~  ", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()) }


    var testSchedule = Schedule(name: "", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
    
    
    @State var currentDate = Date()
    
    @State var daysList = [[DateValue]]()
    
    //@State var clickedDates: Set<Date> = []
    //@State private var clickedDates: Set<Date> = Set()
    
    //화살표 클릭에 의한 월 변경 값
    @State var monthOffset = 0
    
    
    
    private func customFont(size: CGFloat, maxSize: CGFloat) -> Font {
        let scaledSize = min(size, maxSize)
        
        guard let customFont = UIFont(name: "Pretendard", size: scaledSize) else {
            return Font.system(size: scaledSize)
        }
        return Font(customFont)
    }
    
    
    var body: some View {
        
        VStack() {
            
            //            Text("🗓️ 이달의 스케줄")
            //                .font(
            //                    Font.custom("Pretendard", fixedSize: 24)
            //                        .weight(.semibold)
            //                )
            //                .dynamicTypeSize(.large)
            //                .kerning(0.6)
            //                .foregroundColor(.black)
            //                .frame(width: UIScreen.main.bounds.size.width * (185/430), height: UIScreen.main.bounds.size.width * (130/430))
            //                .aspectRatio(1/1, contentMode: .fill)
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 342, height: 441)
                .background(
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                        
                        VStack() {
                            headerView
                            Divider()
                                .frame(width: 302)
<
                            weekView

                            
                            cardView
                            Divider()
                                .frame(width: 302)
                            
                            bookingView
                                .padding([.horizontal,.vertical], 24)
                            
                        }
                        
                        
                    }
                )
            
        }
        //        Rectangle()
        //            .foregroundColor(.clear)
        //            .frame(width: 342, height:231)
        //            .background(
        //                ZStack {
        //                    Rectangle()
        //                        .foregroundColor(.white)
        //                        .cornerRadius(12)
        //                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
        //                    VStack {
        //                        pickerView()
        //                    }
        //                }
        //                )
    }
    
    
    
    private var headerView: some View {
        HStack {
            
            Button {
                monthOffset -= 1
            } label: {
                Image("angle-left")
                
            }
            
            Text(month())
            
                .font(
                    Font.custom("Pretendard", fixedSize: 24)
                        .weight(.semibold)
                )
                .kerning(0.6)
                .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                .minimumScaleFactor(0.7)
                .padding()
            
            
            
            
            Button {
                monthOffset += 1
            } label: {
                Image("angle-right")
                
            }
            //.buttonStyle(BasicButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 부모 스택의 크기를 가득 채우도록 설정
        
    }
    
    private var weekView: some View {
        //let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
        let days = ["  일", "월", "화", "수", "목", "금", "토"]
        
        
        return
        
        HStack(spacing:24) {
            
            ForEach(days.indices, id: \.self) { index in
                Text(days[index])
                
                    .font(.custom("Pretendard",fixedSize: 18))
                
                    .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(index == 0 ? .red : (index == days.count - 1 ? Color(UIColor.customBlue) : .black))
                
                
            }
            
            
        }
        .minimumScaleFactor(0.1)
        .padding([.leading, .trailing], 10)
        .frame(width: UIScreen.main.bounds.width / 13)
        .frame(height: 40)
        
        
        
    }
    
    private var cardView: some View {
        
        VStack() {
            ForEach(daysList.indices, id: \.self) { i in
                
                HStack() {
                    
                    ForEach(daysList[i].indices, id: \.self) { j in

                        CardView(value: $daysList[i][j], schedule: testSchedule)

                        
                    }
                }
                .minimumScaleFactor(0.1)
                
            }
        }
        
        .onChange(of: monthOffset) { _ in
            // updating Month...
            currentDate = getCurrentMonth()
            daysList = extractDate()
        }
        .task {
            daysList = extractDate()
        }
        
        
    }
    

    private var bookingView: some View {
        HStack() {
            Text("예약 가능")
                .frame(width: 70, height: 26)
                .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.45, green: 0.76, blue: 0.87), lineWidth: 1)
                    
                )
                .onTapGesture {
                    
                }
            
            Text("예약 마감")
                .frame(width: 70, height: 26)
                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                .cornerRadius(45)
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold)
                )
            
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 1, green: 0.27, blue: 0.27), lineWidth: 1)
                )
            Text("휴무")
                .frame(width: 70, height: 26)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            
                .cornerRadius(45)
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
                    
                )
            
        }
    }
    
    //    private var bookingView: some View {
    //
    //
    //            VStack(alignment:.leading) {
    //                HStack {
    //                    Image("Ellipse 62")
    //                        .frame(width: 12, height: 12)
    //
    //                    Text("예약 가능")
    //                        .font(
    //                            Font.custom("Pretendard", fixedSize: 14)
    //                                .weight(.semibold)
    //                        )
    //                        .kerning(0.35)
    //                        .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
    //
    //                }
    //                HStack {
    //                    Image("Ellipse 63")
    //                        .frame(width: 12, height: 12)
    //
    //                    Text("예약 마감")
    //                        .font(
    //                            Font.custom("Pretendard", fixedSize: 14)
    //                                .weight(.semibold)
    //                        )
    //                        .kerning(0.35)
    //                        .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
    //                }
    //
    //                HStack {
    //                    Image("Ellipse 64")
    //                        .frame(width: 12, height: 12)
    //                    Text("휴무")
    //                        .font(
    //                            Font.custom("Pretendard", fixedSize: 14)
    //                                .weight(.semibold)
    //                        )
    //                        .kerning(0.35)
    //                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
    //                }
    //            }
    //
    //
    //    }
    
    /**
     현재 날짜 년도
     */
    func year() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY"
        
        return formatter.string(from: currentDate)
    }
    
    /**
     현재 날짜 월
     */
    func month() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: currentDate)
    }
    
    /**
     현재 월 로드.
     monthOffset 값에 변경이 있을 경우 해당 월 로드
     */
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.monthOffset, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    /**
     현재 월의 일수 로드 (달력 남은 공간을 채우기 위한 이전달 및 다음달 일수 포함)
     */
    func extractDate() -> [[DateValue]] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        //이전달 일수로 남은 공간 채우기
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: days.first?.date ?? Date())
        
        let prevMonthLastDay = prevMonthDate?.getLastDayInMonth() ?? 0
        
        for i in 0..<firstWeekDay - 1 {
            days.insert(DateValue(day: prevMonthLastDay - i, date: calendar.date(byAdding: .day, value: -1, to: days.first?.date ?? Date()) ?? Date(), isNotCurrentMonth: true), at: 0)
        }
        
        //다음달 일수로 남은 공간 채우기
        let lastWeekDay = calendar.component(.weekday, from: days.last?.date ?? Date())
        
        let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: days.first?.date ?? Date())
        
        let nextMonthFirstDay = nextMonthDate?.getFirstDayInMonth() ?? 0
        
        for i in 0..<7 - lastWeekDay {
            days.append(DateValue(day: nextMonthFirstDay + i, date: calendar.date(byAdding: .day, value: 1, to: days.last?.date ?? Date()) ?? Date(), isNotCurrentMonth: true))
        }
        
        //달력과 같은 배치의 이차원 배열로 변환하여 리턴
        var result = [[DateValue]]()
        
        days.forEach {
            if result.isEmpty || result.last?.count == 7 {
                result.append([$0])
            } else {
                result[result.count - 1].append($0)
            }
        }
        
        return result
        
    }
    
}
    
    struct CardView: View {
        

        @Binding var value: DateValue

        
        @State var schedule: Schedule
        
        @State private var showSheet = false
        @State private var selectedDate = Date()

        var body: some View {
            ZStack() {
                ZStack() {
                    if value.isSelected {
                        
                        
                    }
                }
                
                
                
                
                HStack {
                    
                    if value.day > 0 {
                        if value.isNotCurrentMonth {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                .foregroundColor(Color(red: 0.87, green: 0.87, blue: 0.87))
                                .padding([.leading, .bottom], 10)
                        } else {
                            if schedule.startDate.withoutTime() < value.date && value.date <= schedule.endDate
                            {
                                Text("\(value.day)")
                                    .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                    .foregroundColor(value.isSelected ? Color(red: 0.45, green: 0.76, blue: 0.87) : (value.isSecondSelected ? .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : Color(red: 1, green: 0.27, blue: 0.27)))
                                //                                .foregroundColor(value.isSelected ? Color(red: 0.45, green: 0.76, blue: 0.87) : Color(red: 1, green: 0.27, blue: 0.27))
                                    .padding([.leading, .bottom], 10)
                                    .onTapGesture {
                                        
                                        value.selectedToggle()
                                        // 클릭할 때마다 클릭 여부를 변경
                                        
                                        print("tap\(value.isSelected)")
                                        //                                    value.selected(isSelected: true)
                                    }
                                
                            } else if schedule.startDate.withoutTime() == value.date {
                                Text("\(value.day)")
                                    .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                    .foregroundColor(.white)
                                    .padding([.leading, .bottom], 10)
                                    .background(Circle()
                                        .frame(width: 40, height: 40)
                                                
                                        .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                                        .offset(x:5.2,y:-3.7)
                                    )
                                
                            } else if schedule.startDate.withoutTime() > value.date {
                                Text("\(value.day)")
                                    .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                    .foregroundColor(value.isSelected ? Color(red: 0.45, green: 0.76, blue: 0.87) : (value.isSecondSelected ? Color(red: 1, green: 0.27, blue: 0.27) : .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))))
                                    .padding([.leading, .bottom], 10)
                                //                                .onTapGesture {
                                //
                                //                                    value.selectedToggle()// 클릭할 때마다 클릭 여부를 변경
                                //                                    print("tap\(value.isSelected)")
                                //                                    value.selected(isSelected: true)
                                //                                }
                            }
                            else {
                                Text("\(value.day)")
                                    .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                    .foregroundColor((value.date.weekday == 1 || value.date.weekday == 2) ? .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : (value.isSelected ? .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : (value.isSecondSelected ? Color(red: 1, green: 0.27, blue: 0.27) : Color(UIColor.customBlue))))
                                //                            .foregroundColor(value.date.weekday == 1 || value.date.weekday == 2 ? .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : value.date.weekday == 7 ? Color(UIColor.customBlue) : .black) //일요일 red 토요일 blue
                                    .padding([.leading, .bottom], 10)
                                    .onTapGesture {
                                        
                                        value.selectedToggle()// 클릭할 때마다 클릭 여부를 변경
                                        print("tap\(value.isSelected)")
                                        //                                    value.selected(isSelected: true)
                                    }
                            }
                        }
                    }
                    
                    // Spacer()
                    
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width / 13)
            .frame(height: 40)
            //.frame(maxHeight: .infinity)
            //.contentShape(Rectangle())
            
        }
 
    }

   
    //struct pickerView: View {
    //    @Environment(\.dismiss) var dismiss
    //    @Environment(\.colorScheme) var colorScheme
    //    @State private var selectedDate = Date()
    //
    //
    //
    //    //@State private var selectedFlavor = Flavor.chocolate
    //    init() {
    //     UIDatePicker.appearance().backgroundColor = UIColor.init(.clear) // changes bg color
    //            UIDatePicker.appearance().tintColor = UIColor.init(.blue) // changes font color
    //
    //    }
    //
    //
    //    var body: some View {
    //        HStack {
    //
    //
    //            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
    //
    //
    //                        //.environment(\.colorScheme, .light)
    //                .colorMultiply(Color(red: 0.45, green: 0.76, blue: 0.87))
    //                        //.colorInvert()
    //                            .labelsHidden()
    //                            //.accentColor(.clear)
    //                            .datePickerStyle(WheelDatePickerStyle())
    //                            .environment(\.locale, Locale(identifier: "ko_GB"))
    //                            .opacity(1)
    //                            .onAppear {
    //                                UIDatePicker.appearance().locale?.hourCycle
    //                                UIDatePicker.appearance().minuteInterval = 10
    //
    //                            }
    //                            .onTapGesture {
    //                                dismiss()
    //                            }
    //                            .foregroundColor(Color.red)
    //                            .background(
    //                                RoundedRectangle(cornerRadius: 10)
    //                                    .foregroundColor(.clear)
    //                                    .frame(width: 342, height: 241)
    //                                    .opacity(1.0)
    //                                    .padding()
    //                            )
    //                            .padding()
    //
    //
    //
    //        }
    //
    //    }
    //
    //
    //
    //
    //}
    




#Preview {
    CalendarView()
    
}
