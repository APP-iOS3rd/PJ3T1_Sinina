//
//  ChatRoom.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation
import FirebaseFirestore

struct ChatRoom: Codable, Hashable {
    var id: String
    var userEmail: String
    var userName: String
    var date: Timestamp
    // var message: [Message]
    
    init(userEmail: String, userName: String, date: Timestamp = Timestamp(date: Date()), id: String = UUID().uuidString) {
        self.id = id
        self.userEmail = userEmail
        self.userName = userName
        self.date = date
    }

    
}

