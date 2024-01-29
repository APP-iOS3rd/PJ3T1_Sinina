//
//  File.swift
//  SininaCake
//
//  Created by 김수비 on 1/28/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

// MARK: FirebaseManager
class FirebaseManager: ObservableObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let user: User?
    let uid: String?
    let email: String?
    
    static let shared = FirebaseManager()
    
    init() {
    
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        self.user = self.auth.currentUser
        self.uid = self.user?.uid
        self.email = self.user?.email
    }
    
}

