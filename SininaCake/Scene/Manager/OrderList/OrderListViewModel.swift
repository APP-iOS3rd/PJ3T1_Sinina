//
//  OrderListViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import Firebase

class OrderListViewModel: ObservableObject {
    @Published var assignOrderData: [OrderItem] = []
    @Published var notAssignOrderData: [OrderItem] = []
    @Published var completeOrderData: [OrderItem] = []
    
    var db: Firestore!
    var ordersRef: CollectionReference!
    
    init() {
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        ordersRef = db.collection("CurrentOrders")
        
        fetchData()
    }
    
    func fetchData() {
        let query: Query = ordersRef.order(by: "id")
        
        query.getDocuments { [weak self] querySnapshot, error in
            if let error: Error = error {
                fatalError("Error getting documents: \(error.localizedDescription)")
            } else if querySnapshot?.documents.isEmpty == true {
                // snapshot이 비어있을 때
                
            } else {
                if let snapshot = querySnapshot, let self = self {
                    for doc in snapshot.documents {
                        let documentData: [String: Any] = doc.data()
                        print(documentData)
                        
                        let id: String = documentData["id"] as? String ?? ""
                        let date: Timestamp = documentData["date"] as? Timestamp ?? Timestamp()
                        let orderTime: Timestamp = documentData["orderTime"] as? Timestamp ?? Timestamp()
                        let cakeSize: String = documentData["size"] as? String ?? ""
                        let sheet: String = documentData["sheet"] as? String ?? ""
                        let cream: String = documentData["cream"] as? String ?? ""
                        let icePack: Bool = documentData["icePack"] as? Bool ?? false
                        let name: String = documentData["name"] as? String ?? ""
                        let phoneNumber: String = documentData["phoneNumber"] as? String ?? ""
                        let text: String = documentData["text"] as? String ?? ""
                        let imageURL: [String] = documentData["imageURL"] as? [String] ?? []
                        let comment: String = documentData["comment"] as? String ?? ""
                        let expectedPrice: Int = documentData["expectedPrice"] as? Int ?? 0
                        let confirmedPrice: Int = documentData["confirmedPrice"] as? Int ?? 0
                        let status: String = documentData["status"] as? String ?? ""
                        
                        let orderDate = OrderItem(id: id, date: self.timestampToDate(date), orderTime: self.timestampToDate(orderTime), cakeSize: cakeSize, sheet: sheet, cream: cream, icePack: icePack, name: name, phoneNumber: phoneNumber, text: text, imageURL: imageURL, comment: comment, expectedPrice: expectedPrice, confirmedPrice: confirmedPrice, status: self.stringToStatus(status))
                        
                        if self.stringToStatus(status) == .assign {
                            assignOrderData.append(orderDate)
                        } else if self.stringToStatus(status) == .notAssign {
                            notAssignOrderData.append(orderDate)
                        } else if self.stringToStatus(status) == .complete {
                            completeOrderData.append(orderDate)
                        }
                    }
                }
            }
        }
    }
    
    private func timestampToDate(_ date: Timestamp) -> Date {
        return date.dateValue()
    }
    
    private func stringToStatus(_ status: String) -> OrderStatus {
        switch status {
        case "승인":
            return .assign
        case "미승인":
            return .notAssign
        case "완료":
            return .complete
        default:
            return .notAssign
        }
    }
}
