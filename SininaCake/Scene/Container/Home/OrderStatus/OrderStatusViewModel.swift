//
//  OrderStatusViewModel.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import Foundation
import Firebase
import FirebaseStorage

class OrderStatusViewModel: ObservableObject {
    let loginVM = LoginViewModel.shared
    let storage = Storage.storage()
    @Published var myOrderData: [OrderItem] = []
    @Published var image: UIImage? = nil
    
    var db: Firestore!
    var ordersRef: CollectionReference!
    
    init() {
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        ordersRef = db.collection("Users").document(loginVM.loginUserEmail ?? "").collection("Orders")
    }
    
    func downloadImage(_ id: String, _ imageName: String) {
        let storage = Storage.storage()
        
        
        let storageRef = storage.reference().child("\(id)/\(imageName)")
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("Cannot download image \(error.localizedDescription)")
                return
            } else {
                if let imageData = data, let self = self, let uiImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.image = uiImage
                    }
                }
            }
        }
    }
    
    func fetchData() {
        myOrderData = []
        
        let query: Query = ordersRef.order(by: "id")
        
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
                        
                        let orderDate = OrderItem(id: id, email: email, date: self.timestampToDate(date), orderTime: self.timestampToDate(orderTime), cakeSize: cakeSize, sheet: sheet, cream: cream, icePack: stringToIcePack(icePack), name: name, phoneNumber: phoneNumber, text: text, imageURL: imageURL, comment: comment, expectedPrice: expectedPrice, confirmedPrice: confirmedPrice, status: self.stringToStatus(status))
                        
                        myOrderData.append(orderDate)
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
