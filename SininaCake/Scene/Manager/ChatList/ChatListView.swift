//
//  ChatListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI
import Firebase

struct ChatListView: View {
    @ObservedObject var chatVM = ChatViewModel.shared
    @ObservedObject var userStore = UserStore.shared
    @State var loginUser: User? // 현재 접속자(본인)
 
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        NavigationLink(destination: ChatView(loginUser: loginUser, userEmail: room.userEmail, room: room)){
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width:55, height: 55)
                                
                                VStack {
                                    HStack {
                                        CustomText(title: "\(room.userName)", textColor: .black, textWeight: .semibold, textSize: 18)
                                            .frame(alignment: .leading)
                                        
                                        Spacer()
                                        
                                        if let lastMessageTimestamp = chatVM.lastMessageTimestamp[room.id] {
                                            CustomText(title: "\(lastMessageTimestamp)", textColor: .customGray, textWeight: .semibold, textSize: 12)
                                                .frame(alignment: .leading)
                                        }
                                    }
                                    .padding(3)
                                    
                                    HStack {
                                        if let lastMessageText = chatVM.lastMessageText[room.id] {
                                            
                                            CustomText(title: "\(lastMessageText)", textColor: .customGray, textWeight: .regular, textSize: 16)
                                        }
                                        
                                        Spacer()
                                        
                                        CustomText(title: "1", textColor: .customGray, textWeight: .regular, textSize: 16)
                                            .frame(alignment: .leading)
                                        
                                    }
                                }
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding()
                            
                        }
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    CustomText(title: "채팅방", textColor: .black, textWeight: .semibold, textSize: 24)}}
        }
        .onAppear(){
            chatVM.fetchAllRooms()}
    }
}

#Preview {
    ChatListView(loginUser: User(name: "아무개", email: "k@gmail.com", createdAt: Timestamp(date: Date()), id: "KYhEjCvYERI4CyoGlZPu"))
}
