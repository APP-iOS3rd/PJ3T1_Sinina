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
    @State var loginUserEmail: String? // 현재 접속자(본인)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(chatVM.chatRooms, id: \.self){ room in
                        NavigationLink(destination: ManagerChatView(room: room)){
                            HStack {
                                // 프로필 사진
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
                                            .frame(alignment: .leading)
                                        
                                        Spacer()
                                        
                                        if let lastMessageTimestamp = room.lastMsgTime?.formattedDate() {
                                            CustomText(title: "\(lastMessageTimestamp)", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                                                .frame(alignment: .leading)
                                        }
                                    }
                                    .padding(3)
                                    
                                    HStack {
                                        if let lastMessageText = room.lastMsg {
                                            CustomText(title: "\(lastMessageText)", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                                        }
                                        Spacer()
                                        
                                        //FIXME: 안읽은 메세지 수
                                        CustomText(title: "1", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
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
        }
        .onAppear(){
            chatVM.fetchAllRooms()
        }
    }
}

#Preview {
    ChatListView(loginUserEmail: LoginViewModel().loginUserEmail)
}
