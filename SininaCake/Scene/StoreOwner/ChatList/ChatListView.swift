//
//  ChatListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.

import SwiftUI
import Firebase
import Kingfisher

struct ChatListView: View {
    @ObservedObject var chatVM = ChatViewModel.shared
    @State var loginUserEmail: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        NavigationLink(destination: ManagerChatView(room: room)){
                            HStack {
                                if let image = room.imgURL {
                                    AsyncImage(url: URL(string: image)){ img in
                                        img.image?
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 55, height: 55)
                                            .clipShape(Circle())
                                            .padding(.trailing, 10)
                                    }
                                } else {
                                    Image("icon_profile")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 55, height: 55)
                                        .background(Color(.customLightGray))
                                        .clipShape(Circle())
                                        .padding(.trailing, 10)
                                }
                                
                                VStack {
                                    HStack {
                                        CustomText(title: "\(room.userEmail)", textColor: .black, textWeight: .semibold, textSize: 18)
                                        Spacer()

                                        if let lastMessageTimestamp = room.lastMsgTime?.formattedDate() {
                                            CustomText(title: "\(lastMessageTimestamp)", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                                        }
                                    }
                                    .padding(UIScreen.UIWidth(3))

                                    HStack {
                                        if let lastMessageText = room.lastMsg {
                                            CustomText(title: "\(lastMessageText)", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                                        }
                                        Spacer()
                                        
                                        if let unreadMsgCnt = room.unreadMsgCnt {
                                            if unreadMsgCnt != 0 {
                                                CustomText(title: "\(unreadMsgCnt)", textColor: .white, textWeight: .regular, textSize: 16)
                                                    .background(Circle()
                                                        .fill(Color(.customBlue))
                                                        .frame(width: UIScreen.UIWidth(22), height: UIScreen.UIHeight(22)))
                                            }
                                        }
                                    }
                                    .padding(.trailing, UIScreen.UIWidth(10))   
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear(){
            chatVM.fetchAllRooms()
        }
    }
}

#Preview {
    ChatListView(loginUserEmail: LoginViewModel().loginUserEmail)
}
