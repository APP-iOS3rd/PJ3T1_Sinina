//
//  ChatRoom.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation
import FirebaseFirestore

struct ChatRoom: Codable, Hashable, Identifiable {
    var id: String
    var userEmail: String
    var userName: String?
    var date: Date?
    
    init(userEmail: String, userName: String?, date: Date?, id: String = UUID().uuidString) {
        self.id = id
        self.userEmail = userEmail
        self.userName = userName
        self.date = date
    }
}

