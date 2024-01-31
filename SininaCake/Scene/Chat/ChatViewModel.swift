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
    
    private init() {}
    
    @Published var chatRooms = [ChatRoom]()
    @Published var messages = [Message]()
    @Published var currentRoom: ChatRoom?
    
    private var fireStore = FirebaseManager.shared.firestore
    
    let collectionName = "chatRoom"
    var listener: ListenerRegistration?
    
    // 모든 방 리스트를 받아옴
    func fetchAllRooms() {
        fireStore.collection(collectionName).getDocuments { (snapshot, error) in
            guard error == nil else { return }
            
            self.chatRooms.removeAll()
            
            for document in snapshot!.documents {
                if let data = try? document.data(as: ChatRoom.self) {
                    self.chatRooms.append(data)
                    
                    print("data", data)
                }
            }
        }
    }
    
    // 받아오는 room
    func fetchRoom(userEmail: String) {
        Task {
            let snapshot = try? await fireStore.collection(collectionName).whereField("userEmail", isEqualTo: userEmail).getDocuments()
            
            // 쿼리 결과인 snapshot의 chatRoom을 가져옴
            if let document = snapshot!.documents.first {
                if let data = try? document.data(as: ChatRoom.self) {
                    self.currentRoom = data
                    
                    // 동시에 해당 chatRoom의 메세지를 가져옴
                    startListening(chatRoom: data)
                    
                    print("data", data)
                }
            }
        }
    }
    
    // 채팅룸 추가
    func addChatRoom(chatRoom: ChatRoom) {
        try? fireStore.collection(collectionName).document(chatRoom.id).setData(from: chatRoom)
    }
    
    func stopListening() {
        listener?.remove()
        messages.removeAll()
        print("stopListening")
    }
    
    // 메세지 패치(메세지 가져오기)
    func startListening(chatRoom: ChatRoom) {
        
        // 기존 채팅방 관찰을 중지
        stopListening()
        
        listener = fireStore.collection(collectionName).document(chatRoom.id).collection("message").addSnapshotListener { querySnapshot, error in
            DispatchQueue.main.async {
                guard let snapshot = querySnapshot, error == nil else {
                    print("Error: \(error!)")
                    return
                }
                
                // 추가된 게 관찰되면 data를 message에 추가
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        if let data = try? diff.document.data(as: Message.self) {
                            self.messages.append(data)
                            print("add data", data)
                        }
                    }
                }
            }
            
            
        }
    }
    
    // 메세지 보냄(방 데이터, 보내는 사람, 메세지 필요)
    func sendMessage(chatRoom: ChatRoom?, message: Message) {
        
        if let chatRoom = chatRoom {
            try? fireStore.collection(collectionName).document(chatRoom.id)
                .collection("message").document(message.id).setData(from: message)
        }
    }
}
    
    //        fireStore.collection("chatRoom").document("id").collection("message").getDocuments { (snapshot, error) in
    //            guard error == nil else { return }
    //
    //            // 기존 목록 비우기
    //            self.chatRooms.removeAll()
    //
    //            // 새로운 목록으로 채우기
    //            for document in snapshot!.documents {
    //                let data = document.data()
    //
    //                print("data", data)
    //                                self.chatRooms.append (
    //                                    ChatRoom (
    //                                        id: document.documentID,
    //                                        userEmail: data["userEmail"] as? String ?? "",
    //                                        userName: data["userName"] as? String ?? "",
    //                                        date: data["date"] as? t ?? Date(),
    //                                        message: data["message"] as? [Message] ?? [Message]())
    //                                )
    //            }
    
    
    
    
    //        fireStore.collection("chatRoom").document("id").collection("message")
    //            .addSnapshotListener { querySnapshot, error in
    //
    //            guard let documents = querySnapshot?.documents else {
    //                print("Error fetching documents: \(error!)")
    //                return
    //            }
    //
    //            self.chatRoom.messages = documents.compactMap { document -> Message? in
    //                do {
    //                    return try document.data(as: Message.self)
    //                } catch {
    //                    print("Error decoding document into Message: \(error)")
    //                    return nil
    //                }
    //            }
    
    //            self.chatRoom.message.sort {$0.timestamp < $1.timestamp}
    //
    //            if let id = self.chatRoom.messages.last?.id {
    //                self.lastMessageId = id
    //            }
    //        }
    
    
    
        
        //                do {
        //                    let newMessage = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
        //
        //                    try fireStore.collection("message").document().setData(from: newMessage)
        //
        //                } catch {
        //                    print("Error adding message to Firestore: \(error)")
        //                }
        //
        //                guard let currnetUser = Auth.auth().currentUser else { return }
        //
        //                let message = [
        //                    "sender": currnetUser.uid,
        //                    "text": newMessageText
        //                ]
        //
        //                fireStore.addDocument(data: message){ error in
        //                    if let error = error {
        //                        print("Error sending message: \(error)")
        //                    } else {
        //                        self.newMessageText = ""
        //                    }
        //                }
        //       }


