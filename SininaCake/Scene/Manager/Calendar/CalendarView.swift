//
//  CalendarView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct CalendarView01: View {
    let testSchedule = Schedule(name: "이벤트 기간", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date())
    
    @State var currentDate = Date()
    @State var daysList = [[DateValue]]()
    
    //화살표 클릭에 의한 월 변경 값
    @State var monthOffset = 0
    //날짜 설정 버튼
    @State private var showAlert = false
    var body: some View {
        VStack(spacing: 0) {
            
            //년월 및 월 변경 버튼
            HStack() {
                    Button {
                        monthOffset -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.customBlue))
                    }
//                    Text(year())
//                        .font(.caption)
//                        .fontWeight(.semibold)
                    Text(month())
                        .foregroundStyle(Color(UIColor.customBlue))
                        //.font(UIFont.pretendard(size: , weight: UIFont.))
                
               
                //.buttonStyle(BasicButtonStyle())
                
                Button {
                    monthOffset += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color(UIColor.customBlue))
                }
                //.buttonStyle(BasicButtonStyle())
                    
                    
                //Spacer()
            } //HStack
            .padding(.horizontal)
            .padding(.bottom, 10)
            .padding(.top, 10)
            //.padding(.leading, 100)
            //요일
            HStack() {
                
                Button("Alert") {
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text("이것은 Alert입니다."),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
            .foregroundColor(Color(UIColor.customBlue))
            .offset(x: 110, y: -30)
            
            
            Group {
                let days = ["일", "월", "화", "수", "목", "금", "토"]
                
                
                HStack(spacing: 7) {
                    
                    
                    ForEach(days.indices, id: \.self) { index in
                        Text(days[index])
                            .font(.callout)
                            //.fontWeight(.semibold)
                            .padding([.leading,.trailing], 9)
                            
                            .foregroundColor(index == 0 ? .red : (index == days.count - 1 ? Color(UIColor.customBlue) : .black))
                    }
                }
                
            }
             //Group
            
            //일
            Group {
                ForEach(daysList.indices, id: \.self) { i in
                    HStack() {
                        
                        ForEach(daysList[i].indices, id: \.self) { j in
                            CardView(value: daysList[i][j], schedule: testSchedule)
                        }
                    }
                    .minimumScaleFactor(0.1)
                    .padding([.leading,.trailing],10)
                    
                }
                
            }
            
            
           
        } //VStack
        .onChange(of: monthOffset) { _ in
            // updating Month...
            currentDate = getCurrentMonth()
            daysList = extractDate()
        }
        .task {
            daysList = extractDate()
        }
        .border(Color.gray, width: 1)
        
        
    } //body
    
    /**
     각각의 날짜에 대한 달력 칸 뷰
     */
    @ViewBuilder
    func CardView(value: DateValue, schedule: Schedule) -> some View {
        
        ZStack() {
            VStack() {
                if schedule.startDate.withoutTime() <= value.date && value.date <= schedule.endDate {
                    if schedule.startDate.day == value.day {
                        
                            Text(schedule.name)
                                .font(.custom("NotoSansCJKkr-Regular", size: 11))
                                .foregroundColor(Color(UIColor.customBlue))
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
                            .font(.title3.bold())
                            .foregroundColor(.gray)
                            .padding([.leading, .bottom], 10)
                    } else {
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .foregroundColor(value.date.weekday == 1 ? .red : value.date.weekday == 7 ? Color(UIColor.customBlue) : .black) //일요일 red 토요일 blue
                            .padding([.leading, .bottom], 10)
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
        //.padding()
        }
        .frame(width: UIScreen.main.bounds.width / 13)
        .frame(height: 40)
        //.frame(maxHeight: .infinity)
        //.contentShape(Rectangle())
        
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


#Preview {
    CalendarView01()
    
}
