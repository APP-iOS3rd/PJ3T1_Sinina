//
//  ChatView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var chatvm = ChatViewModel()
    @ObservedObject var fbManager = FirebaseManager.shared
    @State var chatText = ""
    
    var chatUser: String
        
    init(chatUser: String) {
        self.chatUser = chatUser
    }
    
    // MARK: 통합 뷰
    var body: some View {
        VStack {
            messagesView
                .navigationTitle(chatUser)
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 10)
            
            chatBottomBar
        }
    }
    
    // MARK: 메세지 창 띄우는 뷰
    private var messagesView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(chatvm.messages, id: \.id) { message in
                        MessageBubble(message: message)
                    } 
                }
                .background(Color.clear)
                .onChange(of: chatvm.lastMessageId){ id in
                    withAnimation {
                        // 마지막 말풍선을 따라 스크롤로 내려감
                        proxy.scrollTo(id, anchor: .bottom)
                    }

                }
            }
        }
    }
    
    //MARK: 채팅 치는 뷰
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundColor(Color.init(UIColor.customGray))
            
            ZStack {
                // 텍스트 입력
                TextField("Enter your message", text: $chatText)
                    .background(Color.init(UIColor.customGray))
                    .cornerRadius(8)
            }
            .frame(height: 40)
            
            Button {
                chatvm.sendMessage(text: chatText)
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(Color.init(UIColor.customGray))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .cornerRadius(4)
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ChatView(chatUser: "사용자 이름")
    }
    
}
