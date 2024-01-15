//
//  CustomText.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct CustomText: View {
    
    let title: String
    let textColor: UIColor
    let textWeight: Font.Weight
    let textSize: CGFloat
    
    init(title: String, textColor: UIColor, textWeight: Font.Weight, textSize: CGFloat) {
        self.title = title
        self.textColor = textColor
        self.textWeight = textWeight
        self.textSize = textSize
    }
    
    var body: some View {
        Text(title)
            .font(.custom("Pretendard", size: textSize))
            .fontWeight(textWeight)
            .foregroundStyle(Color(textColor))
    }
}
