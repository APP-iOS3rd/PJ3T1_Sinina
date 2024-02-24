//
//  ChatView2.swift
//  SininaCake
//
//  Created by 김수비 on 2/14/24.
//

import SwiftUI

struct CustomerChatView: View {
    
    @ObservedObject var chatVM = ChatViewModel.shared
    @ObservedObject var loginVM = LoginViewModel.shared
    @State var chatText = ""
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
                        if chatVM.messages[room.id] != nil {
                            ForEach(chatVM.messages[room.id]!!, id: \.self) { msg in
                                // 나
                                if loginVM.loginUserEmail == msg.userEmail {
                                    blueMessageBubble(message: msg)
                                        .id(msg.id)
                                    
                                    // 상대
                                } else {
                                    grayMessageBubble(message: msg)
                                        .id(msg.id)
                                }
                                
                            } // ForEach
                            .background(Color.clear)
                            
                            // 마지막 메세지로 끌어내리기
                            .onChange(of: chatVM.lastMessageId){ id in
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                    print("마지막 메세지: \(chatVM.lastMessageText)")
                                }
                            }
                            // 첫화면 끌어내리기
                            .onAppear(){
                                withAnimation {
                                    proxy.scrollTo(chatVM.lastMessageId, anchor: .bottom)
                                    print("첫화면 \(chatVM.lastMessageText)")
                                }
                            }
                        }
                    }
                }
                // ScrollViewReader
                .onAppear {
                    chatVM.fetchRoom(userEmail: room.userEmail)
                }
            }
            // VStack
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
            // 사진 버튼
            Button {
                isImagePickerPresented.toggle()
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color(.customBlue))
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(45)
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
            
            ZStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .onAppear(){
                            isChatTextEmpty = false
                        }
                    
                } else {
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
                        let msg = Message(imageData: image, imageURL: "", userEmail: loginVM.loginUserEmail ?? "", timestamp: Date())
                        
                        chatVM.sendMessageWithImage(chatRoom: room, message: msg)
                    }
                    self.selectedImage = nil
                    
                    // text 전송
                } else {
                    let msg = Message(text: chatText, userEmail: loginVM.loginUserEmail ?? "", timestamp: Date())
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
                        .frame(idealWidth: 300, idealHeight: 300, alignment: .trailing)
                    
                    
                },
                           placeholder: {
                    ProgressView()
                })
                
            } else {
                Text("\(message.text ?? "")")
                    .padding()
                    .frame(idealWidth: 300)
                    .font(.custom("Pretendard", fixedSize: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(.white)
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
            if let imageURL = message.imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: message.imageURL ?? "www.google.com"), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(idealWidth: 300, idealHeight: 300, alignment: .leading)
                },
                           placeholder: {
                    ProgressView()
                })
                
            } else {
                Text("\(message.text ?? "")")
                    .padding()
                    .frame(idealWidth: 300)
                    .font(.custom("Pretendard", fixedSize: 16))
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .background(Color(.customLightGray))
                    .cornerRadius(30)
            }
            
            CustomText(title: message.timestamp.formattedDate(), textColor: .customGray, textWeight: .regular, textSize: 12)
            
        } // HStack
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}

//#Preview {
//    CustomerChatView(room: ChatRoom(userEmail: "20subi@gmail.com", id: "20subi@gmail.com", lastMsg: nil, lastMsgTime: nil))
//}
