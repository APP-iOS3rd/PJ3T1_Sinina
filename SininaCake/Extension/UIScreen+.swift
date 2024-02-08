//
//  UIScreen+.swift
//  SininaCake
//
//  Created by 이종원 on 2/8/24.
//

import Foundation
import UIKit

extension UIScreen {
    
    static func UIWidth(_ iPhoneProMaxWidth: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.width * (iPhoneProMaxWidth/430)
    }
    
    static func UIHeight(_ iPhoneProMaxHeight: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.height * (iPhoneProMaxHeight/932)
    }
    
}
