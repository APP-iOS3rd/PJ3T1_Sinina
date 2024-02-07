//
//  ChatViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import Firebase
import FirebaseStorage

class ChatViewModel: ObservableObject {
    static let shared = ChatViewModel()
    private var fireStore = FirebaseManager.shared.firestore
    
    @Published var chatRooms = [ChatRoom]()
    @Published var messages = [String: [Message]?]() // key: 방 uuid, 메세지 배열
    @Published var lastMessageText = [String: String]()
    @Published var lastMessageId = ""
    @Published var lastMessageTimestamp = [String: String]()
    let collectionName = "chatRoom"
    var listeners = [ListenerRegistration]()
    
    // 모든 방 리스트를 받아옴
    func fetchAllRooms() {
        fireStore.collection(collectionName).getDocuments { (snapshot, error) in
            guard error == nil else { return }
            
            self.chatRooms.removeAll() // ChatRoom 전부 지우고
            
            for document in snapshot!.documents {
                if let data = try? document.data(as: ChatRoom.self) {
                    self.chatRooms.append(data) // 다시 채움
                    
                    print("fetchAllRoom: ", data)
                    
                    self.startListening(chatRoom: data) // 여기서 읽어오는 거 시작
                }
            }
        }
    }
    
    // 채팅룸 추가
    func addChatRoom(chatRoom: ChatRoom) {
        // 여기를 user의 이메일로 바로 저장해버리면??
        try? fireStore.collection(collectionName).document(chatRoom.id).setData(from: chatRoom)
    }
    
    func stopListening() {
        listeners.removeAll()
        //messages.removeAll()
        
        print("stopListening")
    }
    
    // 메세지 패치(메세지 가져오기)
    func startListening(chatRoom: ChatRoom) {
        
        let listener = fireStore.collection(collectionName).document(chatRoom.id).collection("message").addSnapshotListener { querySnapshot, error in
            DispatchQueue.main.async {
                guard let snapshot = querySnapshot, error == nil else {
                    print("Error: \(error!)")
                    return
                }
                
                // 추가된 게 관찰되면 data를 message에 추가
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        if let data = try? diff.document.data(as: Message.self) {
                            
                            if self.messages[chatRoom.id] == nil {
                                self.messages[chatRoom.id] = [data]
                            } else {
                                self.messages[chatRoom.id]??.append(data)
                            }
                            
                            // 시간 순에 맞게 정렬
                            self.messages[chatRoom.id]??.sort { $0.timestamp < $1.timestamp }
                            
                            
                            // 마지막 메세지 Id
//                            if let id = self.messages[chatRoom.id]??.last?.id {
//                                self.lastMessageId[chatRoom.id] = id
//                                print("lastMessageID: \(id)")
//                            }
                            
                            if let id = self.messages[chatRoom.id]??.last?.id {
                                self.lastMessageId = id
                                print("lastMessageID: \(id)")
                            }
                            
                            // 마지막 메세지 내용
                            if let lastMessageText = self.messages[chatRoom.id]??.last?.text {
                                self.lastMessageText[chatRoom.id] = lastMessageText
                                print("lastMessagetext: \(lastMessageText)")
                            }
                            
                            // 마지막 메세지 시간
                            if let lastMessageTimestamp = self.messages[chatRoom.id]??.last?.timestamp.formattedDate() {
                                self.lastMessageTimestamp[chatRoom.id] = lastMessageTimestamp
                                print("lastMessageTimestamp: \(lastMessageTimestamp)")
                            }
                            print("startListening")
                        }
                    }
                }
            }
        }
        listeners.append(listener)
    }
    
    // 메세지 보냄(방 데이터, 보내는 사람, 메세지 필요)
    func sendMessage(chatRoom: ChatRoom?, message: Message) {
        
        if let chatRoom = chatRoom {
            try? fireStore.collection(collectionName).document(chatRoom.id)
                .collection("message").document(message.id).setData(from: message)
            
            
            print("sendMessage 함수 실행: \(message)추가")
            print("sendMessage 함수 실행(방이름): \(chatRoom)추가")
        }
    }    
}

