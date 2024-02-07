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
    
    func downloadImage(_ imageNames: [String]) {
        let storage = Storage.storage()
        
        for imageName in imageNames {
            let storageRef = storage.reference().child(imageName)
            
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Cannot download image \(error.localizedDescription)")
                    return
                } else {
                    if let imageData = data, let uiImage = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.images.append(uiImage)
                        }
                    }
                }
            }
        }
    }
}
