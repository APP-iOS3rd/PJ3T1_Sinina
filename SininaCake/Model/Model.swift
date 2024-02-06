//
//  Model.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

struct OrderItem: Hashable {
    var id: String
    var email: String
    var date: Date
    var orderTime: Date
    var cakeSize: String
    var sheet: String
    var cream: String
    var icePack: Bool
    var name: String
    var phoneNumber: String
    var text: String
    var imageURL: [String]
    var comment: String
    var expectedPrice: Int
    var confirmedPrice: Int
    var status: OrderStatus
}

enum OrderStatus {
    case notAssign
    case assign
    case complete
}
