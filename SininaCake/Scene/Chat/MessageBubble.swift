//
//  MessageBubble.swift
//  SininaCake
//
//  Created by 김수비 on 1/29/24.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .trailing : .leading) {
            HStack {
                if !message.received {
                    Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                                            .foregroundStyle(Color.init(UIColor.customGray))
                                            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                            .background(Color.pink)
//                                            .multilineTextAlignment(.trailing)
                                            
                    }
                
                Text(message.text)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(message.received ?
                                Color.init(UIColor.customGray) : Color.init(UIColor.customBlue))
                    .cornerRadius(30)
                
                if message.received {
                    Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                        .foregroundStyle(Color.init(UIColor.customGray))
                }
            } // HStack
            .frame(maxWidth: 300)
            
            
        } // VStack
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
    }
}


#Preview {
    MessageBubble(message: Message(id: "12345", text: "안녕하세요. 케이크 문의 드릴게요. 제가 원하는 케익은 딸기 케이크입니다.",  received: true, timestamp: Date()))
}
