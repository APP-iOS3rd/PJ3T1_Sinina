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
    @ObservedObject var userStore = UserStore.shared
    
    @State var chatText = ""
    @State var loginedUser: User?
    @State var userEmail: String
    
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
                    VStack {
                        ForEach(chatVM.messages, id: \.id) { msg in
                            // 나
                            if loginedUser?.name == msg.userName {
                                blueMessageBubble(message: msg)
                                
                                // 상대
                            } else {
                                grayMessageBubble(message: msg)
                            }
                            
                        }
                        .background(Color.clear)
                        .onChange(of: chatVM.lastMessageId){ id in
                            withAnimation {
                                // 마지막 말풍선을 따라 스크롤로 내려감
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
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
                let msg = Message(text: chatText, userName: "아무개", timestamp: Date())
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
    
    // MARK: - 파란 말풍선
    private func blueMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.timestamp
                .formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
            CustomText(title: message.text, textColor: .white, textWeight: .regular, textSize: 16)
                .padding()
            
            
                .background(Color.init(UIColor.customBlue))
                .cornerRadius(30)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 10)
    }
    
    // MARK: - 회색 말풍선
    private func grayMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.text, textColor: .white, textWeight: .regular, textSize: 16)
                .padding()
                .background(Color.init(UIColor.customGray))
                .cornerRadius(30)
            
            CustomText(title: message.timestamp
                .formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    NavigationView {
//        ChatView(loginedUser: User, userEmail: userEmail)
//    }
//
//}
