//
//  ChatView2.swift
//  SininaCake
//
//  Created by 김수비 on 2/14/24.
//

import SwiftUI

struct ChatView2: View {
    
    @ObservedObject var chatVM = ChatViewModel.shared
    @State var chatText = ""
    @State var loginUserEmail: String? // 로그인 유저
    @State var room: ChatRoom
    @State private var isChatTextEmpty = true
    
    
    // MARK: 통합 뷰
    var body: some View {
        VStack {
            messagesView
//                .navigationTitle(chatVM.currentRoom?.userName ?? "")
//                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 10)
            
            chatBottomBar
        }
    }
    
    // MARK: 메세지 창 띄우는 뷰
    private var messagesView: some View {
        NavigationView {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            if chatVM.messages[room.id] != nil {
                                ForEach(chatVM.messages[room.id]!!, id: \.self) { msg in
                                    // 나
                                    if loginUserEmail == msg.userEmail {
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
            }
            .onAppear {
                chatVM.fetchRoom(userEmail: room.userEmail)
            }
            .navigationTitle("시니나케이크")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    //MARK: 채팅 치는 뷰
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Button {
                let msg = Message(text: chatText, userEmail: loginUserEmail ?? "", timestamp: Date())
                chatVM.sendMessage(chatRoom: room, message: msg)
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(isChatTextEmpty ? Color(.customDarkGray) : Color(.customBlue))
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(isChatTextEmpty ? Color(.customGray) : .white)
                    .cornerRadius(45)
            }
            
            ZStack {
                TextField("", text: $chatText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.customLightGray))
                    .cornerRadius(45)
                    .onChange(of: chatText){ value in
                        isChatTextEmpty = value.isEmpty
                    }
            }
            
            Button {
                let msg = Message(text: chatText, userEmail: loginUserEmail ?? "", timestamp: Date())
                chatVM.sendMessage(chatRoom: room, message: msg)
                
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(isChatTextEmpty ? Color(.customDarkGray) : .white)
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(isChatTextEmpty ? Color(.customGray) : Color(.customBlue))
                    .cornerRadius(45)
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        .background(Color(.customLightGray))
        .cornerRadius(45)
        .padding()
    }
    
    // MARK: - 파란 말풍선
    private func blueMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.timestamp.formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
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
            
            CustomText(title: message.timestamp.formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
        } // VStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ChatView2(loginUserEmail: "a@gmail.com", room: ChatRoom(userEmail: "a@gmail.com", id: "iDe7zgI8rZTbXKTSb7id"))
}