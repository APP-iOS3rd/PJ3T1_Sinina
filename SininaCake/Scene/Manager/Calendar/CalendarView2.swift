//
//  CalendarView2.swift
//  SininaCake
//
//  Created by 박채운 on 1/22/24.
//
//
import SwiftUI

struct CalendarView2: View {
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @State var clickedDates: Set<Date> = []
    @State private var showAlert = false
    
    var body: some View {
        HStack() {
            Image("sininaCakeLogo")
                .resizable()
                .frame(width: 30, height: 30)
            Text("이달의 스케줄")
            Image("sininaCakeLogo")
                .resizable()
                .frame(width: 30, height: 30)
        }
        HStack(){
            
            VStack() {
                
                HStack(){
                    Button("<") {
                        changeMonth(by: -1)
                                }
                    .font(.title2)
                    .foregroundColor(Color(UIColor.customBlue))
                
                    headerView
                    
                    Button(">") {
                        changeMonth(by: +1)
                    }
                    .font(.title2)
                    .foregroundColor(Color(UIColor.customBlue))
//                    .font(.system(size: 20))
                    Spacer()
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
                .padding(.leading, 100)
                    HStack() {
                        ForEach(Self.koreaWeekdaySymbols, id: \.self) { symbol in
                              Text(symbol)
                                .frame(maxWidth: .infinity)
                            }
                }
                VStack(alignment:.leading){
                    
                    calendarGridView
                }
                
            }
            
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.offset = gesture.translation
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -50 {
                            changeMonth(by: 1)
                        } else if gesture.translation.width > 50 {
                            changeMonth(by: -1)
                        }
                        self.offset = CGSize()
                    }
            )
        }
        .padding(.leading,70)
        .padding(.trailing,70)
        .border(Color.gray, width: 1)
        .cornerRadius(10)
        //.shadow(color: Color.gray, radius: 5, x: 0, y: 4)
        .scaleEffect(0.8)
        
    }
  

  private var headerView: some View {
      HStack {
          VStack {
              Text(month, formatter: Self.dateFormatter)
                  .font(.title)
                  .padding(.bottom)
                  .foregroundColor(Color(UIColor.customBlue))
                  .foregroundColor(.black)
                  
          }
      }
     
  }

  

  private var calendarGridView: some View {
      let daysInMonth: Int = numberOfDays(in: month)
      let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1

    return VStack {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                if index < firstWeekday {
                    RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.clear)
          } else {
            let date = getDate(for: index - firstWeekday)
            let day = index - firstWeekday + 1
            let clicked = clickedDates.contains(date)
            
            CellView(day: day, clicked: clicked)
                .onTapGesture {
                    if clicked {
                        clickedDates.remove(date)
                    } else {
                        clickedDates.insert(date)
                }
              }
          }
        }
      }
    }
  }
    
    private var calendarDenoteView: some View {
        VStack() {
            
            Text("o-예약가능")
            Text("x-예약불가능")
        }
    }
}




    
private struct CellView: View {
    var day: Int
    var clicked: Bool = false
    
    //var day2 = Calendar.current.component(.weekday, from: Date()) - 1
    
  init(day: Int, clicked: Bool) {
      self.day = day
      self.clicked = clicked
    
  }
  
  var body: some View {
     
          ZStack {
              Path { path in
                  path.move(to: CGPoint(x:0, y: 0))
                  path.addLine(to: CGPoint(x: 50, y: 0))
              }
              .stroke(.gray, lineWidth: 0.3)
              .padding(.top, -10)
              if clicked {
                  RoundedRectangle(cornerRadius: 5)
                      .foregroundColor(Color(UIColor.customBlue))
                      .padding(.trailing, -8)
                      .padding(.leading, -8)
                      .padding(.bottom, 30)
              }
              
              RoundedRectangle(cornerRadius: 0)
                  .opacity(0)
                  .overlay(Text(String(day)))
              //.foregroundColor(day == 7 ? .red : .black)
              //.background(month.isWeekend == true ? Color.orange : Color.pink)
                  .padding(.bottom, 40)
                  .padding(.top, 5)
              //.foregroundColor(.blue)
              Path { path in
                  path.move(to: CGPoint(x:0, y: 0))
                  path.addLine(to: CGPoint(x: 50, y: 0))
              }
              .stroke(.gray, lineWidth: 0.3)
              .padding(.top, -10)
          
    }
  }
}

//struct DenoteView: View {
//
//    var body: some View {
//        HStack(spacing:0){
//            VStack {
//                Button("클릭하세요") {
//
//                    print("버튼이 클릭되었습니다.")
//                }
//                Button("클릭하세요") {
//
//                    print("버튼이 클릭되었습니다.")
//                }
//            }
//        }
//
//
//    }
//}



private extension CalendarView2 {
    
    
  /// 특정 해당 날짜
  private func getDate(for day: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
  }
  
  /// 해당 월의 시작 날짜
  func startOfMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: month)
    return Calendar.current.date(from: components)!
  }
  
  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
  
    
  /// 월 변경
  func changeMonth(by value: Int) {
    let calendar = Calendar.current
    if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
      self.month = newMonth
    }
  }
}


extension Date {
    var isWeekend: Bool {
        let weekday = Calendar.current.component(.weekday, from: self)
        return weekday == 1 || weekday == 7
    }
}

extension CalendarView2 {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M 월"
    
    return formatter
  }()
  static let koreaWeekdaySymbols = ["일","월","화","수","목","금","토"]
  static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
}


#Preview {
    CalendarView2(month: Date())

}

