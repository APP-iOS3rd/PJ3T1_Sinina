//
//  CustomerCalendarView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI
struct CustomerCalendarView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @StateObject var calendarVM = ManagerCalendarViewModel()
    @State private var selectedDate: Date?
    @State var daysList = [[DateValue]]()
    @ObservedObject var orderData: OrderViewModel
    @State private var selectedTime: String = ""
    @State private var isTimePickerPresented: Bool = false
    
    let excludedDays: IndexSet = [0, 1]
    var testSchedule = Schedule(name: "", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
    var body: some View {
        VStack {
            HStack {
                CustomText(title: "픽업 날짜/시간", textColor: .black, textWeight: .semibold , textSize: 20)
                    .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                Spacer()
                CustomText(title: selectedTime, textColor: .customBlue, textWeight: .semibold, textSize: 20)
                CustomText(title: dateToTime(orderData.orderItem.date), textColor: .customBlue, textWeight: .semibold, textSize: 18)
                    .padding(.trailing,(UIScreen.main.bounds.width) * 24/430)
                    .onTapGesture {
                        isTimePickerPresented.toggle()
                    }
                    .sheet(isPresented: $isTimePickerPresented, content: {
                        TimePickerView(selectedDate: Binding(
                            get: { selectedDate ?? Date() },
                            set: { selectedDate = $0 }
                        ))
                        .presentationDetents([.fraction(0.1)])
                    })
            }
            .scaledToFit()
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: UIScreen.UIHeight(540))
                .padding([.leading,.trailing], UIScreen.UIWidth(24))
                .background(
                    ZStack(alignment:.top){
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
                                .padding([.horizontal,.vertical], 24)
                        }
                    }
                )
                .padding()
        }
        .onDisappear()
        .onAppear() {
            calendarVM.monthOffset = Int(calendarVM.month()) ?? 0
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            print("onappear - 캘린더뷰")
            initialize()
        }
        .onChange(of: calendarVM.monthOffset) { _ in
            // updating Month...
            print("onchange - monthoffset, \(calendarVM.monthOffset)")
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            initialize()
        }
        .onChange(of:calendarVM.dateValues) { _ in
            print("onchange - dataValues , \(calendarVM.dateValues.count)")
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            initialize()
        }
        .onChange(of:selectedDate) { selectedDate in
            print("Selected Date Changed: \(String(describing: selectedDate))")
            if let selectedDate = selectedDate {
                orderData.orderItem.date = selectedDate
                print("Order Item Date Changed: \(orderData.orderItem.date)")
            }
            
        }
    }
    
    private func initialize() {
        for i in daysList.indices {
            for j in daysList[i].indices {
                let currentDate = daysList[i][j].date.withoutTime().toDateString()
                if let dv = calendarVM.dateValues.first(where: { $0.date.withoutTime().toDateString() == currentDate }) {
                    if calendarVM.currentDate.month == dv.date.month {
                        print("onchange - month : \(dv.date.month)")
                        daysList[i][j] = dv
                    }
                }
            }
        }
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
                .opacity(calendarVM.monthOffset <= 0 ? 0 : 1)
        }
        .offset(x: 5)
        .disabled(calendarVM.monthOffset <= 0)
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
            }
            .offset(x: 5)
            .disabled(calendarVM.monthOffset >= 1)
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
                        CustomerCardView(value: $daysList[i][j], schedule: testSchedule, calendarVM:calendarVM, selectedDate: $selectedDate) { selectedDateValue in
                            handleDateClick(dateValue: selectedDateValue)
                        }
                    }
                }
                .minimumScaleFactor(0.1)
            }
        }
    }
    
    private var bookingView: some View {
        HStack() {
            Text("예약 가능")
                .frame(width: 70, height: 26)
                .foregroundColor(Color(red: 0.45, green: 0.76, blue: 0.87))
                .font(
                    Font.custom("Pretendard", fixedSize: 12)
                        .weight(.semibold))
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.45, green: 0.76, blue: 0.87), lineWidth: 1))
            Text("예약 마감")
                .frame(width: 70, height: 26)
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
                .frame(width: 70, height: 26)
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
    
    private func handleDateClick(dateValue: DateValue) {
        selectedDate = dateValue.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: dateValue.date)
        selectedTime = dateString
        print("Filtered Orders for \(dateString)")
    }
}

struct CustomerCardView: View {
    @Binding var value: DateValue
    @State var schedule: Schedule
    @ObservedObject var calendarVM: ManagerCalendarViewModel
    @Binding var selectedDate: Date?
    @State private var showAlert: Bool = false
    @State private var showDetail = false
    var onDateClick: (DateValue) -> Void
    
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
                            .scaleEffect(showDetail ? 1.3 : 1)
                            .onTapGesture {
                                showAlert = true
                                withAnimation {
                                    showDetail.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        showDetail = false
                                    }
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("error"),
                                    message: Text("예약가능날짜가 아닙니다"),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
                    } else {
                        Text("\(value.day)")
                            .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                            .foregroundColor(value.color.color)
                            .padding([.leading, .bottom], 10)
                            .scaleEffect(showDetail ? 1.3 : 1)
                            .onTapGesture {
                                
                                if value.color != .blue {
                                    showAlert = true
                                } else {
                                    onDateClick(value)
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("error"),
                                    message: Text("예약가능날짜가 아닙니다"),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width / 13)
        .frame(height: 40)
    }
}

struct TimePickerView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        let startDate = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: selectedDate) ?? Date()
        let endDate = Calendar.current.date(bySettingHour: 19, minute: 30, second: 0, of: selectedDate) ?? Date()
        
        DatePicker("", selection: $selectedDate, in: startDate...endDate, displayedComponents: [.hourAndMinute])
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            .clipped()
            .onAppear {
                UIDatePicker.appearance().minuteInterval = 10
            }
    }
}

