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
    @Published var progressOrderData: [OrderItem] = []
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
        assignOrderData = []
        notAssignOrderData = []
        progressOrderData = []
        completeOrderData = []
        
        let query: Query = ordersRef.order(by: "orderTime")
        
        query.getDocuments { [weak self] querySnapshot, error in
            if let error = error {
                fatalError("Error getting documents: \(error.localizedDescription)")
            } else {
                if let snapshot = querySnapshot, let self = self {
                    for doc in snapshot.documents {
                        let documentData: [String: Any] = doc.data()
                        
                        let id: String = documentData["id"] as? String ?? ""
                        let email: String = documentData["email"] as? String ?? ""
                        let date: Timestamp = documentData["date"] as? Timestamp ?? Timestamp()
                        let orderTime: Timestamp = documentData["orderTime"] as? Timestamp ?? Timestamp()
                        let cakeSize: String = documentData["size"] as? String ?? ""
                        let sheet: String = documentData["sheet"] as? String ?? ""
                        let cream: String = documentData["cream"] as? String ?? ""
                        let icePack: String = documentData["icePack"] as? String ?? ""
                        let name: String = documentData["name"] as? String ?? ""
                        let phoneNumber: String = documentData["phoneNumber"] as? String ?? ""
                        let text: String = documentData["text"] as? String ?? ""
                        let imageURL: [String] = documentData["imageURL"] as? [String] ?? []
                        let comment: String = documentData["comment"] as? String ?? ""
                        let expectedPrice: Int = documentData["expectedPrice"] as? Int ?? 0
                        let confirmedPrice: Int = documentData["confirmedPrice"] as? Int ?? 0
                        let status: String = documentData["status"] as? String ?? ""
                        
                        let orderData = OrderItem(id: id, email: email, date: self.timestampToDate(date), orderTime: self.timestampToDate(orderTime), cakeSize: cakeSize, sheet: sheet, cream: cream, icePack: stringToIcePack(icePack), name: name, phoneNumber: phoneNumber, text: text, imageURL: imageURL, comment: comment, expectedPrice: expectedPrice, confirmedPrice: confirmedPrice, status: self.stringToStatus(status))
                        
                        if self.stringToStatus(status) == .assign {
                            assignOrderData.append(orderData)
                        } else if self.stringToStatus(status) == .notAssign {
                            notAssignOrderData.append(orderData)
                        } else if self.stringToStatus(status) == .complete {
                            completeOrderData.append(orderData)
                        } else if self.stringToStatus(status) == .progress {
                            progressOrderData.append(orderData)
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
        case "진행중":
            return .progress
        case "제작완료":
            return .complete
        case "수령완료":
            return .pickup
        default:
            return .notAssign
        }
    }

    private func stringToIcePack(_ icePack: String) -> IcePack {
        switch icePack {
        case "없음":
            return .none
        case "보냉팩":
            return .icePack
        case "보냉백":
            return .iceBag
        default:
            return .none
        }
    }
}
