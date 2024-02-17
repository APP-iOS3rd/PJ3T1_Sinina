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
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: 통합 뷰
    var body: some View {
        VStack {
            messagesView
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
                                        proxy.scrollTo(id, anchor: .bottom)
                                    }
                                }
                                .onAppear(){
                                    withAnimation {
                                        proxy.scrollTo(chatVM.lastMessageId, anchor: .bottom)
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image("angle-left-black")
                    })
                }
            }
        }
    }
    
    //MARK: 채팅 치는 뷰
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Button {
                isImagePickerPresented.toggle()
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(isChatTextEmpty ? Color(.customDarkGray) : Color(.customBlue))
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(isChatTextEmpty ? Color(.customGray) : .white)
                    .cornerRadius(45)
            }
            .sheet(isPresented: $isImagePickerPresented){
                ImagePicker(selectedImage: $selectedImage)
            }
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
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
            }
            
            Button {
                // 사진을 보낼 때
                if let selectedImage = selectedImage {
                    if let image = selectedImage.jpegData(compressionQuality: 1){
                        let msg = Message(imageData: image, imageURL: "", userEmail: loginUserEmail ?? "", timestamp: Date())
                        
                        chatVM.sendMessageWithImage(chatRoom: room, message: msg)
                    }
                    self.selectedImage = nil
                   
                // text 전송
                } else {
                    let msg = Message(text: chatText, userEmail: loginUserEmail ?? "", timestamp: Date())
                    chatVM.sendMessage(chatRoom: room, message: msg)
                }
                
                chatText = ""
                isChatTextEmpty = true
                
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(isChatTextEmpty ? Color(.customDarkGray) : .white)
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(isChatTextEmpty ? Color(.customGray) : Color(.customBlue))
                    .cornerRadius(45)
            }
            .disabled(isChatTextEmpty)
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
            
            if let imageURL = message.imageURL, !imageURL.isEmpty {
                
                AsyncImage(url: URL(string: message.imageURL ?? "www.google.com"), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150, maxHeight: 150)
                        .padding()
                        .background(Color(.customBlue))
                        .cornerRadius(30)
                        
                },
                           placeholder: {
                    ProgressView()
                })
                
            } else {
                CustomText(title: message.text ?? "", textColor: .white, textWeight: .regular, textSize: 16)
                    .padding()
                    .background(Color(.customBlue))
                    .cornerRadius(30)
            }
        } // VStack
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 10)
    }
    
    // MARK: - 회색 말풍선
    private func grayMessageBubble(message: Message) -> some View {
        HStack {
            CustomText(title: message.text ?? "", textColor: .black, textWeight: .regular, textSize: 16)
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
