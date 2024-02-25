//
//  CustomXButton.swift
//  SininaCake
//
//  Created by 이종원 on 2/25/24.
//

import SwiftUI

struct CustomXButton: View {
    @Binding var isClicked: Bool
    
    var body: some View {
        Button(action: {
            isClicked.toggle()
        }, label: {
            Image("redX")
                .resizable()
                .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(24))
                .foregroundStyle(.red)
        })
    }
}

//#Preview {
//    CustomXButton()
//}
