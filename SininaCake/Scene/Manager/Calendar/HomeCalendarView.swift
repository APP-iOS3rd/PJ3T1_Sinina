//
//  HomeCalendarView.swift
//  SininaCake
//
//  Created by 박채운 on 2/21/24.
//
import SwiftUI
struct HomeCalendarView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var calendarVM = ManagerCalendarViewModel()
    @State private var selectedDate: Date?
    @State var daysList = [[DateValue]]()
    var testSchedule = Schedule(name: "", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            CustomText(title: "이달의 스케줄", textColor: .black, textWeight: .semibold, textSize: 24)
                .padding(.bottom, 5)
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: UIScreen.UIHeight(540))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                .background(
                    ZStack(alignment:.top) {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 8)
                        VStack() {
                            headerView
                            .fixedSize(horizontal: false, vertical: true)
                            Divider()
                                .frame(width: UIScreen.UIWidth(302))
                            weekView
                            cardView
                            Divider()
                                .frame(width: UIScreen.UIWidth(302))
                                
                            bookingView
                                .padding([.horizontal,.vertical], UIScreen.UIWidth(24))
                            
                        }
                    }
                )
        }
        .padding(.trailing, UIScreen.UIWidth(24))
        .padding(.leading, UIScreen.UIWidth(24))
        
    }

    private var headerView: some View {
        HStack {
            Spacer()
            Spacer()
            Button {
                calendarVM.monthOffset -= 1
                
            }
        label: {
                Image("angle-left")
                .opacity(calendarVM.monthOffset <= -1 ? 0 : 1)
                        .scaleEffect(calendarVM.monthOffset <= -1 ? 0.001 : 1)
            }
            .offset(x: 5)
            Text(calendarVM.month())
                .font(
                    Font.custom("Pretendard", fixedSize: 24)
                        .weight(.semibold))
                .kerning(0.6)
                .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                .minimumScaleFactor(0.7)
                .padding()
                .offset(x: 5)
            Button {
                calendarVM.monthOffset += 1
            } label: {
                Image("angle-right")
                    .opacity(calendarVM.monthOffset >= 1 ? 0 : 1)
                            .scaleEffect(calendarVM.monthOffset >= 1 ? 0.001 : 1)
            }
            .offset(x: 5)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var weekView: some View {
        
        let days = ["  일", "월", "화", "수", "목", "금", "토"]
        
        return HStack(spacing:24) {
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
                        HomeCardView(value: $daysList[i][j], schedule: testSchedule, calendarVM:calendarVM, selectedDate: $selectedDate)
                    }
                }
                .minimumScaleFactor(0.1)
            }
        }
        .onDisappear()
        .onAppear() {
            calendarVM.monthOffset = Int(calendarVM.month()) ?? 0
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            print("onappear - 캘린더뷰")
            for dv in calendarVM.dateValues {
                if calendarVM.currentDate.month == dv.date.month {
                    print("onchange - month : \(dv.date.month)")
                    for i in daysList.indices {
                        for j in daysList[i].indices {
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].day == dv.day {
                                daysList[i][j] = dv
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: calendarVM.monthOffset) { _ in
            // updating Month...
            print("onchange - monthoffset, \(calendarVM.monthOffset)")
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            for dv in calendarVM.dateValues {
                if calendarVM.currentDate.month == dv.date.month {
                    print("onchange - month : \(dv.date.month)")
                    for i in daysList.indices {
                        for j in daysList[i].indices {
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].day == dv.day {
                                daysList[i][j] = dv
                            }
                        }
                    }
                }
            }
        }
        .onChange(of:calendarVM.dateValues) { _ in
            print("onchange - dataValues , \(calendarVM.dateValues.count)")
            for dv in calendarVM.dateValues {
                if calendarVM.currentDate.month == dv.date.month {
                    print("onchange - month : \(dv.date.month)")
                    for i in daysList.indices {
                        for j in daysList[i].indices {
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].day == dv.day {
                                daysList[i][j] = dv
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var bookingView: some View {
        HStack() {
            Text("예약 가능")
                .frame(width: UIScreen.UIWidth(70), height: UIScreen.UIWidth(26))
                .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold))
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.45, green: 0.76, blue: 0.87), lineWidth: 1))
            Text("예약 마감")
                .frame(width: UIScreen.UIWidth(70), height: UIScreen.UIWidth(26))
                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
                .cornerRadius(45)
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold))
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 1, green: 0.27, blue: 0.27), lineWidth: 1))
            Text("휴무")
                .frame(width: UIScreen.UIWidth(70), height: UIScreen.UIWidth(26))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                .cornerRadius(45)
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold))
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1))
        }
    }
}

struct HomeCardView: View {
    @Binding var value: DateValue
    @State var schedule: Schedule
    @ObservedObject var calendarVM: ManagerCalendarViewModel
    @Binding var selectedDate: Date?
    
    var body: some View {
            ZStack() {
                HStack {
                    if value.day > 0 {
                        if value.isNotCurrentMonth {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                .foregroundColor(Color(UIColor.customGray))

                                .padding([.leading, .bottom], 10)
                        } else if schedule.startDate.withoutTime() == value.date {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                .foregroundColor(.white)
                                .padding([.leading, .bottom], 10)
                                .background(Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(UIColor.customBlue))
                                    .offset(x:5.2,y:-3.7)
                                )
                        } else {
                            Text("\(value.day)")
                                .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                                .foregroundColor(value.color.color)
                                .padding([.leading, .bottom], 10)
                                .onTapGesture {
                                    
                                }
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width / 13)
            .frame(height: 40)
    }
}

#Preview {
    HomeCalendarView()
}
