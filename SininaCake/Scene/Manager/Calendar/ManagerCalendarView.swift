//
//  CalendarView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//
import SwiftUI
struct ManagerCalendarView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    @ObservedObject var calendarVM = ManagerCalendarViewModel()
    @StateObject var calendarListVM = ManagerCalendarListViewModel()
    @State private var selectedDate: Date?
    @State var editClicked = false
    @State var daysList = [[DateValue]]()
    @State var edit: Bool = false
    
    var testSchedule = Schedule(name: "", startDate: Date(), endDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
    var body: some View {
        ScrollView {
            Spacer()
            Spacer()
            VStack() {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: UIScreen.UIHeight(540))
                    .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(UIColor.customBlue).opacity(1), lineWidth: 1) // 테두리 색 및 두께 조절
                        )
                    .background(
                        ZStack(alignment:.top){
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            VStack() {
                                headerView
                                    .fixedSize(horizontal: false, vertical: true)
                                Divider()
                                    .frame(width: 302)
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
            .padding(.trailing, UIScreen.UIWidth(24))
            .padding(.leading, UIScreen.UIWidth(24))
            VStack {
                if edit {
                    if let selectedDate = selectedDate {
                        let formattedDateString = calendarVM.convert(date: selectedDate)
                        CalListView(orderData: calendarListVM.allOrderData.filter { dateToString($0.date).contains(formattedDateString) }, title: "주문 내역", titleColor: .black)
                        let _ = print(formattedDateString)
                    }
                }
            }
            .onAppear {
                calendarListVM.fetchData()
                calendarVM.removePastDateValues()
                print("view 로드, 현재시간 이전 데이터 삭제")
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
            Button {
                print("편집 작동, \(edit)")
                edit.toggle()
                editClicked.toggle()
            } label: {
                Text(editClicked ? "일정편집" : "목록보기")
                    .font(
                        Font.custom("Pretendard", fixedSize: 16)
                            .weight(.semibold))
                    .foregroundColor(editClicked ? Color(.customBlue) : Color(.customBlue))
                    
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 부모 스택의 크기를 가득 채우도록 설정
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
                        let _ = print("CardViewload \(daysList[i][j].color)")
                        CardView(value: $daysList[i][j], schedule: testSchedule, calendarVM:calendarVM, edit: $edit, calendarListVM: calendarListVM, selectedDate: $selectedDate) { selectedDateValue in
                            handleDateClick(dateValue: selectedDateValue)
                        }

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
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].date.withoutTime().toDateString() == dv.date.withoutTime().toDateString() {
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
            //calendarVM.loadDataFromFirestore() -> 어차피 리스너로 실시간 반영해서 로드할 필요x

            for dv in calendarVM.dateValues {
                if calendarVM.currentDate.month == dv.date.month {
                    print("onchange - month : \(dv.date.month)")
                    for i in daysList.indices {
                        for j in daysList[i].indices {                       
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].date.withoutTime().toDateString() == dv.date.withoutTime().toDateString() {
                                daysList[i][j] = dv
//                                let _ = print("daylistid\(String(describing: daysList[i][j].date.withoutTime().toDateString())) ,dv.id \(String(describing: dv.date.withoutTime().toDateString())) ")
                            }
                        }
                    }
                }
            }
        }
        .onChange(of:calendarVM.dateValues) { _ in
            print("onchange - dataValues , \(calendarVM.dateValues.count)")
            calendarVM.currentDate = calendarVM.getCurrentMonth()
            daysList = calendarVM.extractDate()
            for dv in calendarVM.dateValues {
                if calendarVM.currentDate.month == dv.date.month {
                    print("onchange - month : \(dv.date.month)")
                    for i in daysList.indices {
                        for j in daysList[i].indices {
                            if !daysList[i][j].isNotCurrentMonth && daysList[i][j].date.withoutTime().toDateString() == dv.date.withoutTime().toDateString() {
                                daysList[i][j] = dv
                                print(" dv 컬러 \(dv.color.color)")
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
        // 날짜기준 ListView 데이터 필터링
        // 예시로 "yyyy/MM/dd" 형식의 문자열을 기준으로 필터링하도록 구현
        selectedDate = dateValue.date.withoutTime()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.string(from: dateValue.date)
        let filteredOrders = calendarListVM.allOrderData.filter { order in
            dateToString(order.date).contains(dateString)
        }
        // 필터링된 데이터를 사용하여 UI 업데이트 등을 수행
        // 여기에서는 print만 수행
        print("Filtered Orders for \(dateString): \(filteredOrders)")
    }
}

struct CardView: View {
    @Binding var value: DateValue
    @State var schedule: Schedule
    @ObservedObject var calendarVM: ManagerCalendarViewModel
    @Binding var edit: Bool
    @StateObject var calendarListVM: ManagerCalendarListViewModel
    @Binding var selectedDate: Date?
    var onDateClick: (DateValue) -> Void
    @State private var showDetail = false

    
    var body: some View {
        ZStack() {
            ZStack {
                let formattedDateString = calendarVM.convert(date: value.date)
                if !CalListView(orderData: calendarListVM.allOrderData.filter { dateToString($0.date).contains(formattedDateString)}, title: "주문 내역", titleColor: .black).orderData.isEmpty {

                    Text(".")
                        .font(.system(size: 30))
                        .offset(x: 5, y: 2)
                }
            }
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
                                withAnimation {
                                    showDetail.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        showDetail = false
                                    }
                                }
                            }
                    } else {
                        Text("\(value.day)")
                            .font(.custom("Pretendard-SemiBold", fixedSize: 18))
                            .foregroundColor(value.color.color)
                            .padding([.leading, .bottom], 10)
                            .scaleEffect(showDetail ? 1.3 : 1)
                            .onTapGesture {
                                withAnimation {
                                    showDetail.toggle()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        showDetail = false
                                    }
                                }
                                let dateValue = DateValue(day: value.day, date: value.date.withoutTime())
                                if edit == false && schedule.startDate.withoutTime() < value.date {
                                    if value.color == .blue {
                                        value.color = .gray
                                        //calendarVM.changeDateColorToGray(date: value.date)
                                    } else if value.color == .gray {
                                        
                                        value.color = .red
                                    } else if value.color == .red {
                                        
                                        value.color = .blue
                                    }
                                } else {
                                    onDateClick(value)
                                    print("\(value) 클릭")
                                }
                                calendarVM.saveDateValueToFirestore(dateValue: value)
                                calendarVM.removeDuplicateDay(dateValue: dateValue)
                            }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width / 13)
        .frame(height: UIScreen.UIHeight(40))
    }
}

#Preview {
    ManagerCalendarView()
}
