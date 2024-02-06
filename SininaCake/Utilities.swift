//
//  Utilities.swift
//  SininaCake
//
//  Created by 이종원 on 1/25/24.
//

import Foundation
import UIKit

final class Utilities {

    static var rootViewController: UIViewController {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
