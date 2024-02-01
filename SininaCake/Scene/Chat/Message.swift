//
//  Message.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    var id: String // 아이디로 말풍선 위치 결정
    var text: String
    var timestamp: Date
    var userName: String
    
    init(text: String, userName: String, timestamp: Date, id: String = UUID().uuidString) {
        self.id = id
        self.text = text
        self.userName = userName
        self.timestamp = timestamp
    }
}
