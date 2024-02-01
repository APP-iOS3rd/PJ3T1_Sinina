//
//  ChatView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI
import Firebase

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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                CustomText(title: "\(chatVM.currentRoom?.userName ?? "")", textColor: .black, textWeight: .semibold, textSize: 24)
            }
        }
    }
    
    //MARK: 채팅 치는 뷰
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus")
                .frame(width: 24, height: 24)
                .foregroundColor(Color(.customGray))
            
            ZStack {
                TextField("", text: $chatText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.textFieldColor))
                    .cornerRadius(45)
            }
            
            Button {
                let msg = Message(text: chatText, userName: loginedUser?.name ?? "", timestamp: Date())
                chatVM.sendMessage(chatRoom: chatVM.currentRoom, message: msg)
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(Color(.customGray))
                    .frame(width: 24, height: 24)
            }
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
                .background(Color(.customBlue))
                .cornerRadius(30)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 10)
    }
    
    // MARK: - 회색 말풍선
    private func grayMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.text, textColor: .black, textWeight: .regular, textSize: 16)
                .padding()
                .background(Color(.textFieldColor))
                .cornerRadius(30)
            
            CustomText(title: message.timestamp
                .formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
    NavigationView {
        //ChatView(loginedUser: User, userEmail: userEmail)
        ChatView(loginedUser: User(name: "아무개", email: "c@gmail.com", createdAt: Timestamp(date: Date()), id: "KYhEjCvYERI4CyoGlZPu"), userEmail: "b@gmail.com")
    }
    
}
