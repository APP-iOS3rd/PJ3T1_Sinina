//
//  UserConfirmOrderDetailViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 2/26/24.
//

import Foundation
import Firebase

class UserConfirmOrderDetailViewModel: ObservableObject {
    @Published var managerList: [String] = []
    @Published var deviceToken: [String] = []
    var db: Firestore!
    var ordersRef: CollectionReference!
    
    init() {
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        
        db = Firestore.firestore()
        ordersRef = db.collection("Managers")
    }
    
    @MainActor
    func fetchManagerList(completion: @escaping () -> Void) async {
        managerList = []
        
        do {
            let managers = try await ordersRef.document("Manager").getDocument()
            if let managerArr = managers.data()?["email"] as? [String] {
                    self.managerList = managerArr
            } else {
                print("Cannot found email in document")
            }
        } catch let error {
            print("Firebase error: \(error.localizedDescription)")
        }
        completion()
    }
    
    func getDeviceToken(_ emails: [String]) {
        deviceToken = []
        
        for email in emails {
            let docRef = db.collection("Users").document(email)
            
            docRef.getDocument { [weak self] doc, error in
                if let error = error {
                    print("FireStore Error: \(error.localizedDescription)")
                    return
                }
                
                if let doc = doc, doc.exists, let self = self {
                    let data = doc.data()
                    if let data = data {
                        let token = data["deviceToken"] as? String ?? ""
                        self.deviceToken.append(token)
                    }
                }
            }
        }
    }
}
