//
//  ChatView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct ChatView: View {
    
    let chatUser = "이찰떡"
    @State var chatText = ""
    @ObservedObject var chatvm = ChatViewModel()
    
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.chatvm = ChatViewModel
//    }
    
    var body: some View {
        messagesView
        .navigationTitle(chatUser)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ForEach(0..<10) { num in
                        HStack {
                            Spacer()
                            
                            HStack {
                                Text("Fake Message for now")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.init(UIColor.customBlue))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    HStack{ Spacer() }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(
                            .systemBackground)
                            .ignoresSafeArea()
                        )
                }
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16 ) {
            Image(systemName: "plus")
                .font(.system(size: 24))
                .foregroundColor(Color.init(UIColor.customGray))
            
            ZStack {
                TextEditor(text: $chatvm.chatText)
                    .opacity(chatvm.chatText.isEmpty ? 0.5 : 1 )
                    .background(Color.init(UIColor.customGray))
                    .cornerRadius(8)
            }
            .frame(height: 40)
            
            Button {
                //chatvm.handleSend()
            } label: {
                Image(systemName: "paperplane")
                    .foregroundColor(Color.init(UIColor.customGray))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .cornerRadius(4)
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ChatView()
    }
    
}
