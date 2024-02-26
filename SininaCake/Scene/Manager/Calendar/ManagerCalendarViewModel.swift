//
//  CalendarViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//
import SwiftUI
import Firebase
import FirebaseFirestore
 //날짜 칸 표시를 위한 일자 정보
struct DateValue: Identifiable, Decodable, Comparable {

    var id: String?
    var day: Int
    var date: Date
    var isNotCurrentMonth: Bool = false
    var color: TextColor

    enum TextColor: String, Decodable {
        case blue
        case red
        case gray
        case notcurrent
        var color: Color {
            switch self {
            case .blue:
                return Color(UIColor.customBlue)
            case .red:
                return Color(UIColor.customRed)
            case .gray:
                return Color(UIColor.customDarkGray)
            case .notcurrent:
                return Color(UIColor.customGray)
            }
        }
    }
    
    
    init(day: Int, date: Date, color: TextColor? = nil, isNotCurrentMonth: Bool = false) {
        self.day = day
        self.date = date
        self.isNotCurrentMonth = isNotCurrentMonth
        self.color = color ?? .notcurrent
        self.id = "\(date.year)-\(date.month)-\(date.day)"
    }
    
    static func < (lhs: DateValue, rhs: DateValue) -> Bool {
        return lhs.day < rhs.day
    }
}

 //일정 정보
struct Schedule: Codable {
    var name: String
    var startDate: Date
    var endDate: Date

     //일정 표시 색깔 지정
    var color = Color(.white)
    
    enum CodingKeys: String, CodingKey {
        case name, startDate, endDate
    }
}

extension DateValue {
  
    init?(documentData: [String: Any]) {
        guard
            let day = documentData["day"] as? Int,
            let dateTimestamp = documentData["date"] as? Timestamp,
            let isNotCurrentMonth = documentData["isNotCurrentMonth"] as? Bool,
            let colorString = documentData["color"] as? String,
            let color = TextColor(rawValue: colorString)
        else {
            return nil
        }
        
        self.day = day
        self.date = dateTimestamp.dateValue()
        self.isNotCurrentMonth = isNotCurrentMonth
        self.color = color

        self.id = date.withoutTime().toDateString()


    }
    
    var toFirestore: [String: Any] {
        [
            "day": day,
            "date": Timestamp(date: date),
            "isNotCurrentMonth": isNotCurrentMonth,
            "color": color.rawValue
        ]
    }
}

class ManagerCalendarViewModel: ObservableObject {
    
    @Published var dateValues: [DateValue] = []
    @Published var currentDate = Date()
    @Published var monthOffset = 0 
 
    private var listener: ListenerRegistration?
    
    init() {
        observeFirestoreChanges()
    }
  
    func convert(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func observeFirestoreChanges() {
        let db = Firestore.firestore()
        let collectionReference = db.collection("dateValues")
        
        
        listener = collectionReference.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("문서를 가져오는 데 오류가 발생했습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            self.dateValues = documents.compactMap { queryDocumentSnapshot in
                do {
                    // Firestore에서 직렬화된 데이터를 가져와서 DateValue로 변환
                    let data = try queryDocumentSnapshot.data(as: DateValue.self)
                    return data
                } catch {
                    print("DateValue로의 데이터 변환 중 오류가 발생했습니다: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
  
    func saveDateValueToFirestore(dateValue: DateValue) {
        let db = Firestore.firestore()
        let documentReference = db.collection("dateValues").document(dateValue.date.withoutTime().toDateString())
        print("\(dateValue.date.withoutTime().toString() ), 데이터 저장")
        documentReference.setData(dateValue.toFirestore) { error in
            if let error = error {
                print("Error saving DateValue to Firestore: \(error.localizedDescription)")
            } else {
                print("DateValue saved to Firestore successfully.")
            }
        }
    }
    
    /// Firestore 데이터 읽어오기
    func getDateValueFromFirestore(documentID: String, completion: @escaping (DateValue?) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection("dateValues").document(documentID)
        
        documentReference.getDocument { document, error in
            if let error = error {
                print("Error getting DateValue from Firestore: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let documentData = document?.data(),
               let dateValue = DateValue(documentData: documentData) {
                completion(dateValue)
            } else {
                completion(nil)
            }
        }
    }


//    func loadDataFromFirestore() {
//        let db = Firestore.firestore()
//        let collectionReference = db.collection("dateValues")
//        print("loadDataFromFirestore")
//
//        collectionReference.getDocuments { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("문서를 가져오는 데 오류가 발생했습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
//                return
//            }
//            print("documents/ ")
//
//            self.dateValues.removeAll()
//            self.dateValues = documents.compactMap { queryDocumentSnapshot in
//                do {
//                    let data = try queryDocumentSnapshot.data(as: DateValue.self)
//                    return data
//                } catch {
//                    print("DateValue로의 데이터 변환 중 오류가 발생했습니다: \(error.localizedDescription)")
//                    return nil
//                }
//            }
//        }
//    }
    
    func removeDuplicateDay(dateValue: DateValue) {
        let db = Firestore.firestore()
        let collectionReference = db.collection("dateValues")
        
        let query = collectionReference
            .whereField("date", isEqualTo: dateValue.date.withoutTime())
            .limit(to: 2) // 중복된 경우 2개 이상이 될 수 있으므로 limit을 설정
        
        query.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("중복된 데이터 조회 중 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            // 중복된 데이터가 2개 이상이면 삭제
            if documents.count >= 2 {
                for i in 1..<documents.count {
                    let documentID = documents[i].documentID
                    db.collection("dateValues").document(documentID).delete { error in
                        if let error = error {
                            print("중복된 데이터 삭제 중 오류: \(error.localizedDescription)")
                        } else {
                            print("중복된 데이터 삭제 완료")
                        }
                    }
                }
            }
        }
    }

    private func timestampToDate(_ date: Timestamp) -> Date {
        return date.dateValue()
    }


    func removePastDateValues() {
        let db = Firestore.firestore()
        let collectionReference = db.collection("dateValues")
        
        // 현재 날짜와 비교해서 현재 시간 이전인 데이터를 쿼리
        let query = collectionReference
            .whereField("date", isLessThan: Timestamp(date: Date()))
        
        query.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("과거 데이터 조회 중 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            // 조회된 데이터를 모두 삭제
            for document in documents {
                let documentID = document.documentID
                db.collection("dateValues").document(documentID).delete { error in
                    if let error = error {
                        print("과거 데이터 삭제 중 오류: \(error.localizedDescription)")
                    } else {
                        print("과거 데이터 삭제 완료")
                    }
                }
            }
        }
    }
    
    //현재 날짜 년도
    func year() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY"
        
        return formatter.string(from: currentDate)
    }
    
    //현재 날짜 월
    func month() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: currentDate)
    }
    
    // 현재 월 로드, monthOffset 값에 변경이 있을 경우 해당 월 로드
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.monthOffset, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    //현재 월의 일수 로드 (달력 남은 공간을 채우기 위한 이전달 및 다음달 일수 포함)
    func extractDate() -> [[DateValue]] {
      
        let calendar = Calendar.current
           
           let currentMonth = getCurrentMonth()
           
           var days = currentMonth.getAllDates().compactMap { date -> DateValue in
               let day = calendar.component(.day, from: date)
               let isNotCurrentMonth = !calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
               
               var color: DateValue.TextColor
               
               if monthOffset < 0 {
                   // 1. monthOffset이 0보다 작으면 무조건 .gray
                   color = .gray
               } else if monthOffset == 0 {
                   // 2. monthOffset이 0일 경우
                   if date < currentDate.withoutTime() {
                       // 2-1. 오늘 이전은 .gray
                       color = .gray
                   } else if date == Calendar.current.date(byAdding: .day, value: 1, to: currentDate.withoutTime()) {
                       // 2-2. 오늘+1은 .red
                       color = .red
                   } else if date == Calendar.current.date(byAdding: .day, value: 2, to: currentDate.withoutTime()) {
                       // 2-3. 오늘+2는 .red
                       color = .red
                   } else {
                       // 2-4. 그 외의 오늘이후는 .blue
                       color = .blue
                   }
               } else if monthOffset > 0 {
                   // 3. monthOffset이 0보다 크면
                   if date.weekday == 1 || date.weekday == 2 {
                       // 3-1. weekday가 1, 2일 경우 .gray
                       color = .gray
                   } else {
                       // 3-2. 그 외에는 .blue
                       color = .blue
                   }
               } else {
                   // 위의 모든 조건에 해당하지 않는 경우
                   color = .red
               }
              
               return DateValue(day: day, date: date, color: color, isNotCurrentMonth: isNotCurrentMonth)
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

    deinit {
        listener?.remove()
    }
  
}

extension Date {
   
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    func toDateString() -> String {
           let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
           dateFormatter.dateFormat = "yyyy-MM-dd"
           return dateFormatter.string(from: self)
       }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        //getting start Date...
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
   
    func getLastDayInMonth() -> Int {
        let calendar = Calendar.current
        
        return (calendar.range(of: .day, in: .month, for: self)?.endIndex ?? 0) - 1
    }
    
    func getFirstDayInMonth() -> Int {
        let calendar = Calendar.current
        
        return (calendar.range(of: .day, in: .month, for: self)?.startIndex ?? 0)
    }
    
    func withoutTime() -> Date {
        let dateComponents = DateComponents(year: self.year, month: self.month, day: self.day)
        
        return Calendar.current.date(from: dateComponents) ?? self
    }
}
