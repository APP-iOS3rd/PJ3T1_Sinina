//
//  CustomButton.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct CustomButton: View {
    
    let action: () -> Void
    let title: String
    let titleColor: UIColor
    let backgroundColor: UIColor
    let leading: CGFloat
    let trailing: CGFloat
    
    init(action: @escaping () -> Void, title: String, titleColor: UIColor, backgroundColor: UIColor, leading: CGFloat, trailing: CGFloat) {
        self.action = action
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.leading = leading
        self.trailing = trailing
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: action, label: {
                CustomText(title: title, textColor: titleColor, textWeight: .semibold, textSize: 18)
            })
            .frame(minHeight: 55)
            Spacer()
        }
        .background(Color(backgroundColor))
        .cornerRadius(27.5)
        .padding(.leading, leading)
        .padding(.trailing, trailing)
    }
}
