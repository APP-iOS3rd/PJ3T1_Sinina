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
    var lastMsg: String?
    var lastMsgTime: Date?
    var imgURL: String?
//    var date: Date?
    
    init(userEmail: String, id: String, lastMsg: String?, lastMsgTime: Date?, imgURL: String?) {
        self.id = userEmail
        self.userEmail = userEmail
        self.lastMsg = lastMsg
        self.lastMsgTime = lastMsgTime
        self.imgURL = imgURL
//        self.date = date
    }
}

