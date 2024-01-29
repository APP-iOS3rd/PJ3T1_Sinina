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
    
    @Published var messages: [Message] = []
    @Published var newMessageText = ""
    @Published var lastMessageId = ""
    
    private var fireStore = FirebaseManager.shared.firestore

    
    init() {
        getMessages()
    }
    
    // 메세지 띄움
    func getMessages() {
        fireStore.collection("messages").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            
            self.messages.sort {$0.timestamp < $1.timestamp}
            
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    // 메세지 보냄
    func sendMessage(text: String) {
        
        do {
            let newMessage = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
            
            try fireStore.collection("messages").document().setData(from: newMessage)
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
        
//        guard let currnetUser = Auth.auth().currentUser else { return }
//        
//        let message = [
//            "sender": currnetUser.uid,
//            "text": newMessageText
//        ]
        
//        fireStore.addDocument(data: message){ error in
//            if let error = error {
//                print("Error sending message: \(error)")
//            } else {
//                self.newMessageText = ""
//            }
//        }
    }
    
}
