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
    
    func downloadImage(_ imageName: String) -> UIImage {
        var image = UIImage()
        
        storage.reference(forURL: "gs://sininacake.appspot.com/\(imageName)").downloadURL { (url, error) in
            guard let url = url else {
                print("Cannot Found Firebase Storege url")
                return
            }
            
            guard let error = error else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            DispatchQueue.main.async {
                let data = NSData(contentsOf: url)
                image = UIImage(data: data! as Data)!
            }
        }
        
        return image
    }
}