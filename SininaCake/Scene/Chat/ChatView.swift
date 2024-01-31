//
//  ChatView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var chatVM = ChatViewModel.shared
    @ObservedObject var fbManager = FirebaseManager.shared
    @State var chatText = ""
    var userEmail: String

    // MARK: 통합 뷰
    var body: some View {
        VStack {
            messagesView
                .navigationTitle(chatVM.currentRoom?.userName ?? "")
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
                    ForEach(chatVM.messages, id: \.id) { message in
                        MessageBubble(message: message)
                        
                        HStack {
                            // 내가 보낸 거 
                            //if message.userName == chatVM.currentUser {
                                Text(message.text)
                           // } else {
                                
                          //  }
                        }
                }
                .background(Color.clear)
//                .onChange(of: chatvm.lastMessageId){ id in
//                    withAnimation {
//                        // 마지막 말풍선을 따라 스크롤로 내려감
//                        proxy.scrollTo(id, anchor: .bottom)
//                    }
//
                }
            }
        }
        .onAppear {
            chatVM.fetchRoom(userEmail: userEmail)
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
                let msg = Message(text: chatText, userName: "아무개")
                chatVM.sendMessage(chatRoom: chatVM.currentRoom, message: msg)
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
        ChatView(userEmail: "b@gmail.com")
    }
    
}
