//
//  ChatUser.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid, email, name, profileImageUrl, pushToken: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.pushToken = data["pushToken"] as? String ?? ""
    }
}
