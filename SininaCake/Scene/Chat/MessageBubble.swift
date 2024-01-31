//
//  MessageBubble.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import SwiftUI
import FirebaseFirestore

struct BlueMessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack {
            HStack{
                Text(message.text)
                    .foregroundColor(Color.white)
                    
                
                Text("\(message.timestamp)")
                    .foregroundStyle(Color.init(UIColor.customGray))
                
            } // HStack
            .frame(maxWidth: 300)
            .background(Color.init(UIColor.customBlue))
            .cornerRadius(30)
            
            
        } // VStack
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }
}


#Preview {
    BlueMessageBubble(message: Message(text: "안녕", userName: "수비", timestamp: Timestamp(date: Date()), id: "!123"))
}

