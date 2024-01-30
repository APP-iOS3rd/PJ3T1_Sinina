//
//  ChatListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct ChatListView: View {
    @ObservedObject var chatVM = ChatViewModel.shared
    
    @State var userEmail: String = ""
    @State var userName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("유저 이메일", text: $userEmail)
                TextField("유저 이름", text: $userName)
                
                HStack {
                    Button("add room"){
                        chatVM.addChatRoom(chatRoom: ChatRoom(userEmail: userEmail, userName: userName))
                    }
                    
                    Button("load room"){
                        chatVM.fetchAllRooms()
                    }
                }
                
                ScrollView {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        Text(room.userName)
                        
                    }
                }
                .navigationTitle("💬 채팅방")
                .navigationBarTitleDisplayMode(.inline)
                
            }.onAppear(){
                chatVM.fetchAllRooms()
            }
        }
        
    }
}

#Preview {
    ChatListView()
}
