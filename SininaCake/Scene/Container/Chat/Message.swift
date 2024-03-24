//
//  Message.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable, Hashable {
    var id: String // 아이디로 말풍선 위치 결정
    var text: String?
    var timestamp: Date
    var userEmail: String?
    var imageURL: String?
    var imageData: Data?
    var viewed: Bool?
    
    // 텍스트 메시지 생성자
    init(text: String, userEmail: String, timestamp: Date, id: String = UUID().uuidString, viewed: Bool?) {
        self.id = id
        self.text = text
        self.userEmail = userEmail
        self.timestamp = timestamp
        self.viewed = viewed
    }
    
    // 이미지 메시지 생성자
    init(imageData: Data, imageURL: String?, userEmail: String, timestamp: Date, id: String = UUID().uuidString, viewed: Bool?) {
        self.id = id
        self.imageURL = imageURL
        self.userEmail = userEmail
        self.timestamp = timestamp
        self.imageData = imageData
        self.viewed = viewed
    }
}
