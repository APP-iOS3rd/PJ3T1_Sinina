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
struct DateValue: Identifiable, Codable, Comparable {
    @DocumentID var id: String?
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

extension DateValue {
  
    init?(documentData: [String: Any]) {
        guard
            let day = documentData["day"] as? Int,
            let dateTimestamp = documentData["date"] as? Timestamp,
            let isNotCurrentMonth = documentData["isNotCurrentMonth"] as? Bool,
            let isSelected = documentData["isSelected"] as? Bool,
            let isSecondSelected = documentData["isSecondSelected"] as? Bool
        else {
            return nil
        }
        self.day = day
        self.date = dateTimestamp.dateValue()
        self.isNotCurrentMonth = isNotCurrentMonth
        self.isSelected = isSelected
        self.isSecondSelected = isSecondSelected
    }
    
    var toFirestore: [String: Any] {
        [
            "day": day,
            "date": Timestamp(date: date),
            "isNotCurrentMonth": isNotCurrentMonth,
            "isSelected": isSelected,
            "isSecondSelected": isSecondSelected
        ]
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
}


class CalendarViewModel: ObservableObject {
    @Published var dateValues: [DateValue] = []
    private var listener: ListenerRegistration?
    
    init() {
        observeFirestoreChanges()
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

    func loadDataFromFirestore() {
        let db = Firestore.firestore()
        let collectionReference = db.collection("dateValues")
        
        collectionReference.getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("문서를 가져오는 데 오류가 발생했습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            self.dateValues.removeAll()
            self.dateValues = documents.compactMap { queryDocumentSnapshot in
                do {
                    let data = try queryDocumentSnapshot.data(as: DateValue.self)
                    return data
                } catch {
                    print("DateValue로의 데이터 변환 중 오류가 발생했습니다: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
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
    
    func getTextColorForDateValue(_ dateValue: DateValue) -> Color {
        if dateValue.isSelected {
            return Color(UIColor.customBlue)
        } else if dateValue.isSecondSelected {
            return Color(UIColor.customRed)
        } else {
            return Color(UIColor.customDarkGray)
        }
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
    
    deinit {
        listener?.remove()
    }
}

