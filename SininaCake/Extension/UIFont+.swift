//
//  UIFont+.swift
//  SininaCake
//
//  Created by  zoa0945 on 12/4/23.
//

import UIKit
import Foundation

extension UIFont {
    static func pretendard(size fontsize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "Pretendard"
        
        var weightString: String
        switch weight {
        /*case .black:
            weightString = "Black"
        case .bold:
            weightString = "Bold"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"*/
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "Semibold"
        /*case .thin:
            weightString = "Thin"*/
        default:
            weightString = "Regular"
        }
        
        return UIFont(name: "\(familyName)-\(weightString)", size: fontsize) ?? .systemFont(ofSize: fontsize, weight: weight)
    }
}
