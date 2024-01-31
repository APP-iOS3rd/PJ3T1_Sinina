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
    @State var title = CustomText(title: "채팅방", textColor: .black, textWeight: .regular, textSize: 24)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        
                        NavigationLink(destination: ChatView(userEmail: room.userEmail)) {
                            Text("\(room.userName)")
                        }
                    }
                }
            }
            .navigationTitle("채팅방")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(){
            chatVM.fetchAllRooms()
            
        }
        
    }
    /*
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
     }*/
}

#Preview {
    ChatListView()
}
