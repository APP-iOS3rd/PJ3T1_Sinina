//
//  Message.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    //var sender: String
    var text: String
    var received: Bool
    var timestamp: Date
}
