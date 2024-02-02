//
//  Model.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

struct OrderItem: Hashable {
    var date: String
    var time: String
    var cakeSize: String
    var sheet: String
    var cream: String
    var customer: String
    var phoneNumber: String
    var text: String
    var imageURL: [String]
    var comment: String
    var price: Int
    var status: OrderStatus
}

enum OrderStatus {
    case notAssign
    case assign
    case complete
}
