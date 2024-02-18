//
//  OrderDetailViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import Firebase
import FirebaseStorage

class OrderDetailViewModel: ObservableObject {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @Published var images: [UIImage?] = []
    @Published var deviceToken: String = ""
    
    func updatePrice(orderItem: OrderItem, _ price: Int) {
//        db.collection("Users").document(orderItem.email).collection("Orders").document(orderItem.id).updateData(["confirmedPrice":price])
        db.collection("CurrentOrders").document(orderItem.id).updateData(["confirmedPrice":price])
    }
    
    func updateStatus(orderItem: OrderItem) {
        switch orderItem.status {
        case .notAssign:
//            db.collection("Users").document(orderItem.email).collection("Orders").document(orderItem.id).updateData(["status":"승인"])
            db.collection("CurrentOrders").document(orderItem.id).updateData(["status":"승인"])
        case .assign:
//            db.collection("Users").document(orderItem.email).collection("Orders").document(orderItem.id).updateData(["status":"완료"])
            db.collection("CurrentOrders").document(orderItem.id).updateData(["status":"완료"])
        default:
            return
        }
    }
    
    func downloadImage(_ id: String, _ imageNames: [String]) {
        images = []
        
        for imageName in imageNames {
            let storageRef = storage.reference().child("\(id)/\(imageName)")
            
            storageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
                if let error = error {
                    print("Cannot download image \(error.localizedDescription)")
                    return
                } else {
                    if let imageData = data, let self = self, let uiImage = UIImage(data: imageData) {
                        print("success download image")
                        DispatchQueue.main.async {
                            self.images.append(uiImage)
                        }
                    }
                }
            }
        }
    }
    
    func getDeviceToken(_ email: String) {
        let docRef = db.collection("Users").document(email)
        
        docRef.getDocument { [weak self] doc, error in
            if let error = error {
                print("FireStore Error: \(error.localizedDescription)")
                return
            }
            
            if let doc = doc, doc.exists, let self = self {
                let data = doc.data()
                if let data = data {
                    self.deviceToken = data["deviceToken"] as? String ?? ""
                }
            }
        }
    }
}
