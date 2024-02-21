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
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    init() {
    
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
}

