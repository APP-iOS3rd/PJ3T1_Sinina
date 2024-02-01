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
    @State var loginedUser: User?
    
    //@State var userEmail: String = ""
    //@State var userName: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        NavigationLink(destination: ChatView(loginedUser: loginedUser, userEmail: room.userEmail)){
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width:55, height: 55)
                                
                                VStack {
                                    HStack {
                                        CustomText(title: "\(room.userName)", textColor: .black, textWeight: .semibold, textSize: 18)
                                            .frame(alignment: .leading)
                                        
                                        Spacer()
                                        
                                        CustomText(title: "5:20", textColor: .black, textWeight: .semibold, textSize: 18)
                                            .frame(alignment: .leading)
                                        
                                    }
                                    .padding(3)
                                    
                                    HStack {
                                        CustomText(title: "내용내용내용내용", textColor: .customGray, textWeight: .regular, textSize: 16)
                                        
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

#Preview {
    ChatListView(loginedUser: User(name: "아무개", email: "k@gmail.com", createdAt: Timestamp(date: Date()), id: "KYhEjCvYERI4CyoGlZPu"))
}
