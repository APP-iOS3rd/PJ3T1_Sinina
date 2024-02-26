//
//  ChatViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import Firebase
import FirebaseStorage

class ChatViewModel: ObservableObject{
    static let shared = ChatViewModel()
    private var fireStore = FirebaseManager.shared.firestore
    
    @Published var chatRooms = [ChatRoom]()
    @Published var messages = [String: [Message]?]() // key: 방 uuid, 메세지 배열
    @Published var lastMessageText = [String: String]()
    @Published var lastMessageId = ""
    @Published var lastMessageTimestamp = [String: String]()
    var listeners = [ListenerRegistration]()
    var listener: ListenerRegistration?
    
    func fetchAllRooms(){
        listener?.remove()
        
        fireStore.collection("chatRoom").getDocuments { (snapshot, error) in
            guard error == nil else { return }
            
            self.removeAll()
            
            for document in snapshot!.documents {
                if let data = try? document.data(as: ChatRoom.self) {
                    self.chatRooms.append(data)
                    
                    self.chatRooms.sort { room1, room2 in
                        if let time1 = room1.lastMsgTime, let time2 = room2.lastMsgTime {
                            return time1 > time2
                        } else if room1.lastMsgTime != nil {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
    }
    
    func removeAll(){
        self.chatRooms.removeAll()
        self.messages.removeAll()
        self.listeners.removeAll()
    }
    
    func fetchRoom(userEmail: String){

        fireStore.collection("chatRoom").whereField("userEmail", isEqualTo: userEmail).getDocuments() { (snapshot, error) in
            guard error == nil else { print("fetch Room 에러 : \(error)")
                return }
            
            self.removeAll()
            
            for document in snapshot!.documents {
                if let data = try? document.data(as: ChatRoom.self) {
                    
                    self.chatRooms.append(data)
                    print("data", data)
                    
                    self.startListening(chatRoom: data)
                }
            }
        }
    }
    func addChatRoom(chatRoom: ChatRoom) {
        try? fireStore.collection("chatRoom").document(chatRoom.id).setData(from: chatRoom)
    }
    
    func startListening(chatRoom: ChatRoom) {

        print("listeningRoom: \(chatRoom)")
        
        listener = fireStore.collection("chatRoom").document(chatRoom.id).collection("message").addSnapshotListener { querySnapshot, error in

                guard let snapshot = querySnapshot, error == nil else {
                    print("Error: \(error!)")
                    return
                }

                snapshot.documentChanges.forEach { diff in
    
                    if (diff.type == .added) {
                        if let data = try? diff.document.data(as: Message.self) {
                            
                            if self.messages[chatRoom.id] == nil {
                                self.messages[chatRoom.id] = [data]
                            } else {
                                self.messages[chatRoom.id]??.append(data)
                            }
                            
                            self.messages[chatRoom.id]??.sort { $0.timestamp < $1.timestamp }
                            
                            if let id = self.messages[chatRoom.id]??.last?.id {
                                self.lastMessageId = id
                            }
                            
                            if let lastMessageText = self.messages[chatRoom.id]??.last?.text {
                                self.lastMessageText[chatRoom.id] = lastMessageText
                            }

                            if let lastMessageTimestamp = self.messages[chatRoom.id]??.last?.timestamp.formattedDate() {
                                self.lastMessageTimestamp[chatRoom.id] = lastMessageTimestamp
                            }
                        }
                    }
                }
        }
        listeners.append(listener!)
    }
    
    func sendMessage(chatRoom: ChatRoom?, message: Message) {
        if let chatRoom = chatRoom {
            try? fireStore.collection("chatRoom").document(chatRoom.id)
                .collection("message").document(message.id).setData(from: message)
            
                try? fireStore.collection("chatRoom").document(chatRoom.id).setData([
                "lastMsg": message.text,
                "lastMsgTime": message.timestamp], merge: true)
        }
    }

    func sendMessageWithImage(chatRoom: ChatRoom, message: Message) {
        
        if let imageData = message.imageData {
            uploadImageToStorage(imageData: imageData) { result in
                
                switch result {
                case .success(let downloadURL):
                    var updatedMessage = message
                    updatedMessage.imageURL = downloadURL.absoluteString // imageURL 채움
                    
                    self.fireStore.collection("chatRoom")
                        .document(chatRoom.id)
                        .collection("message")
                        .document(updatedMessage.id)
                        .setData(["id": updatedMessage.id,
                                  "userEmail": updatedMessage.userEmail,
                                  "text": updatedMessage.text,
                                  "timestamp": updatedMessage.timestamp,
                                  "imageURL": updatedMessage.imageURL])
                    
                    try? self.fireStore.collection("chatRoom").document(chatRoom.id).setData([
                        "lastMsg": "사진을 보냈습니다.",
                        "lastMsgTime": message.timestamp], merge: true)
                
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func uploadImageToStorage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        
        let storageRef = Storage.storage().reference().child("chatImages/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
    
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let downloadURL = url {
                    completion(.success(downloadURL))
                }
            }
        }
    }
}

