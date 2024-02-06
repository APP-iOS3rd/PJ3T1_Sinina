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
    @Published var imageView: UIImage = UIImage()
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
    
    func downloadImage(_ imageName: String) {
        for image in imageName {
            storage.reference(forURL: "gs://sininacake.appspot.com/\(image)").downloadURL { url, error in
                guard let url = url else { return }
                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self,
                          let data = data,
                          response != nil,
                          error == nil else { return }
                    
                    DispatchQueue.main.async {
                        self.imageView = UIImage(data: data) ?? UIImage()
                    }
                }.resume()
            }
        }
    }
}
