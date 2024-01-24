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
    @State private var clickedDates: Set<Date> = Set()
    
    var clicked: Bool = false
    
    
    //화살표 클릭에 의한 월 변경 값
    @State var monthOffset = 0
    
    
    //데이트피커에 의한 날짜 변경값
    @State private var showDatePicker = false
    
    
    @State private var showAlert = false
    
    private func customFont(size: CGFloat, maxSize: CGFloat) -> Font {
        let scaledSize = min(size, maxSize)
        
        guard let customFont = UIFont(name: "Pretendard", size: scaledSize) else {
            return Font.system(size: scaledSize)
        }
        return Font(customFont)
    }
    
    var body: some View {
        
        VStack() {

            Text("🗓️ 이달의 스케줄")
                .font(
                    Font.custom("Pretendard", fixedSize: 24)
                        .weight(.semibold)
                )
                .dynamicTypeSize(.large)
                .kerning(0.6)
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.size.width * (185/430), height: UIScreen.main.bounds.size.width * (130/430))
                .aspectRatio(1/1, contentMode: .fill)
            
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 342, height: 441)
                .background(
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(10), radius: 10, x: 0, y: 8)
                        
                        VStack() {
                                headerView
                            
                                monthView
                                
                                cardView
                        
                            HStack {
                                bookingView
                                
                                Spacer()
                            }
                            .padding([.horizontal,.vertical], 10)
                        }
                        
                        
                    }
                )
        }
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
    
    private var monthView: some View {
        //let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
        let days = ["  일", "월", "화", "수", "목", "금", "토"]
        
        
        return
        
        HStack(spacing:24) {
                
                ForEach(days.indices, id: \.self) { index in
                    Text(days[index])
                        .font(.custom("Pretendard-SemiBold",fixedSize: 18))
                    
                    
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
                        Button(action: {
                            showAlert = true
                            // 버튼이 클릭되었을 때 실행할 코드
                            let date = Date()
                            let clicked = clickedDates.contains(date)
                            if clicked {
                                print("dsdsf")
                                // 클릭된 경우의 동작
                                clickedDates.remove(date)
                                
                            } else {
                                // 클릭되지 않은 경우의 동작
                                print("Button unclicked at \(i), \(j)")
                                clickedDates.insert(date)
                                
                                
   
  
                            }
                        }) {
                            CardView(value: daysList[i][j], schedule: testSchedule)
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("알림"),
                                        message: Text("페이지이동"),
                                        dismissButton: .default(Text("확인"))
                                        
                                    )
                                }
                            
                        }
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

    
    
    @ViewBuilder
    func CardView(value: DateValue, schedule: Schedule) -> some View {
        //var clicked: Bool = false
        
        ZStack() {
            ZStack() {
                if schedule.startDate.withoutTime() <= value.date && value.date <= schedule.endDate {
                
                       
                    if schedule.startDate.day == value.day {
                        
                            Text(schedule.name)
                                .font(.custom("Pretendard-SemiBold", fixedSize: 12))
                                .foregroundStyle(.black)
                                //.foregroundColor(Color(UIColor.customBlue))
                                .lineLimit(2)
                                .multilineTextAlignment(.trailing)
                                .fixedSize()
                                //.frame(width: geometry.size.width, alignment: .trailing)
                        
                    } else  {
//                        Rectangle()
//                            .frame(width: .infinity, height: 20)
//                            .foregroundColor(schedule.color)
//
                    }
                    
                    Spacer()
                } else {
                    Spacer()
                }
                    
                    
            }
            .offset(x: 10, y: -10)
            HStack {
                
                
                if value.day > 0 {
                    if value.isNotCurrentMonth {
                        Text("\(value.day)")
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .foregroundColor(Color(UIColor.customGray))
                            .padding([.leading, .bottom], 10)
                    } else {
                        
                        if schedule.startDate.withoutTime() <= value.date && value.date <= schedule.endDate
                        {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", size: 18))
                                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                                .padding([.leading, .bottom], 10)
                        } else {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", size: 18))
                                .foregroundColor(!(value.date.weekday == 1 || value.date.weekday == 2) ? Color(UIColor.customBlue) : .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)))
                            //                            .foregroundColor(value.date.weekday == 1 || value.date.weekday == 2 ? .init(cgColor: CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)) : value.date.weekday == 7 ? Color(UIColor.customBlue) : .black) //일요일 red 토요일 blue
                                .padding([.leading, .bottom], 10)
                        }
                    }
                }
               // Spacer()
            }
            //커스텀 줄
//            Path { path in
//                path.move(to: CGPoint(x:-10, y: 0))
//                path.addLine(to: CGPoint(x: 30, y: 0))
//
//            }
//            .stroke(.gray, lineWidth: 0.3)
//            .padding()
        }
        .frame(width: UIScreen.main.bounds.width / 13)
        .frame(height: 40)
        //.frame(maxHeight: .infinity)
        //.contentShape(Rectangle())
        
    }
    
    
    private var bookingView: some View {
        
            
            VStack(alignment:.leading) {
                HStack {
                    Image("Ellipse 62")
                        .frame(width: 12, height: 12)
                    
                    Text("예약 가능")
                        .font(
                            Font.custom("Pretendard", fixedSize: 14)
                                .weight(.semibold)
                        )
                        .kerning(0.35)
                        .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                    
                }
                HStack {
                    Image("Ellipse 63")
                        .frame(width: 12, height: 12)
                    
                    Text("예약 마감")
                        .font(
                            Font.custom("Pretendard", fixedSize: 14)
                                .weight(.semibold)
                        )
                        .kerning(0.35)
                        .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                }
                
                HStack {
                    Image("Ellipse 64")
                        .frame(width: 12, height: 12)
                    Text("휴무")
                        .font(
                            Font.custom("Pretendard", fixedSize: 14)
                                .weight(.semibold)
                        )
                        .kerning(0.35)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
            }
        
        
    }
    
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





extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}










#Preview {
    CalendarView()
    
}
