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
    
    // 모든 방 리스트를 받아옴
    func fetchAllRooms(){
        
        listener?.remove()
        print("리스너: \(listener)")
        
        fireStore.collection("chatRoom").getDocuments { (snapshot, error) in
            guard error == nil else { return }
            
            self.chatRooms.removeAll() // ChatRoom 전부 지우고
            self.messages.removeAll()
            self.listener?.remove()
            
            for document in snapshot!.documents{
                if let data = try? document.data(as: ChatRoom.self) {
                    self.chatRooms.append(data) // 다시 채움
                    
                    print("fetchAllRoom: ", data)
                    
                    //self.startListening(chatRoom: data) // 여기서 읽어오는 거 시작
                }
            }
        }
    }
    
    // 하나의 방만 불러옴
    func fetchRoom(userEmail: String){
        print("fetchRoom: \(userEmail)")
        
        // userEmail과 일치하는 방을 찾아서 불러옴
        fireStore.collection("chatRoom").whereField("userEmail", isEqualTo: userEmail).getDocuments() { (snapshot, error) in
            guard error == nil else { print("fetch Room 에러 : \(error)")
                return }
            
            print("AllListeners: \(self.listeners)")
            
            // 기존 목록 비우기
            self.chatRooms.removeAll()
            self.messages.removeAll()
            self.listeners.removeAll()
            
            print("AllListeners: \(self.listeners)")
            
            print("쿼리 결과: \(snapshot!.documents.count)")
            
            // 쿼리 결과인 snapshot의 chatRoom을 가져옴
            for document in snapshot!.documents {
                if let data = try? document.data(as: ChatRoom.self) {
                    
                    self.chatRooms.append(data)
                    print("data", data)
                    
                    // 동시에 해당 chatRoom의 메세지를 가져옴
                    self.startListening(chatRoom: data)
                }
            }
        }
    }
    
    // 채팅룸 추가
    func addChatRoom(chatRoom: ChatRoom) {
        try? fireStore.collection("chatRoom").document(chatRoom.id).setData(from: chatRoom)
    }
    
//    func stopListening() {
//        listeners.removeAll()
//        //messages.removeAll()
//        
//        print("stopListening")
//    }
    
    // 메세지 패치(메세지 가져오기)
    func startListening(chatRoom: ChatRoom) {
//        if listeners.contains(where: { $0.chatRoom.id == chatRoom.id }) {
//                print("이미 채팅방을 관찰 중입니다: \(chatRoom)")
//                return
//        }
        print("listeningRoom: \(chatRoom)")
        
        // 변경사항 처리하는 메커니즘
        listener = fireStore.collection("chatRoom").document(chatRoom.id).collection("message").addSnapshotListener { querySnapshot, error in
                // 구체적인 데이터
                guard let snapshot = querySnapshot, error == nil else {
                    print("Error: \(error!)")
                    return
                }
                
            print("snapshot처음처음처음처음처음: \(snapshot)")
                // 추가된 게 관찰되면 data를 message에 추가
                snapshot.documentChanges.forEach { diff in
                    
                    print("snapshot: \(snapshot)")
                    
                    if (diff.type == .added) {
                        print(".add 호출")
                        if let data = try? diff.document.data(as: Message.self) {
                            
                            if self.messages[chatRoom.id] == nil {
                                self.messages[chatRoom.id] = [data]
                            } else {
                                self.messages[chatRoom.id]??.append(data)
                                print("data message에 저장: \(data.text)")
                                print("messages[20subi@gmail.com] = \(self.messages[chatRoom.id])")
                            }
                            
                        //---
                            
                            // 시간 순에 맞게 정렬
                            self.messages[chatRoom.id]??.sort { $0.timestamp < $1.timestamp }
                            
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
//        listener.remove()
        listeners.append(listener!)
    }
    
    // 메세지 보냄(방 데이터, 보내는 사람, 메세지 필요)
    func sendMessage(chatRoom: ChatRoom?, message: Message) {
        
        // 해당 메세지를 chatRoom에 저장
        if let chatRoom = chatRoom {
            try? fireStore.collection("chatRoom").document(chatRoom.id)
                .collection("message").document(message.id).setData(from: message)
            
                try? fireStore.collection("chatRoom").document(chatRoom.id).setData([
                "lastMsg": message.text,
                "lastMsgTime": message.timestamp], merge: true)

            print("sendMessage 함수 실행")
        }
    }
    
    // 이미지가 있는 경우 Firestore에 메시지를 저장하는 함수
    func sendMessageWithImage(chatRoom: ChatRoom, message: Message) {
        
        if let imageData = message.imageData {
            // 이미지 데이터를 스토리지에 업로드
            uploadImageToStorage(imageData: imageData) { result in
                
                switch result {
                case .success(let downloadURL):
                    // 이미지가 업로드되고 다운로드 URL이 성공적으로 가져온 경우
                    // 해당 URL을 메세지에 설정, FireStore에 저장
                    
                    var updatedMessage = message
                    updatedMessage.imageURL = downloadURL.absoluteString // imageURL 채움
                    
                    // FIRESTORE에 메세지를 저장
                    self.fireStore.collection("chatRoom")
                        .document(chatRoom.id)
                        .collection("message")
                        .document(updatedMessage.id)
                        .setData(["id": updatedMessage.id,
                                  "userEmail": updatedMessage.userEmail,
                                  "text": updatedMessage.text,
                                  "timestamp": updatedMessage.timestamp,
                                  "imageURL": updatedMessage.imageURL])
                    
                    
                    print("print 2: chatRoom: \(chatRoom), updatedMessage: \(updatedMessage)")
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func uploadImageToStorage(imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        
        print("print 1: 스토리지에 업데이트할 데이터: \(imageData)")
        
        // 이미지 파일 저장 공간
        let storageRef = Storage.storage().reference().child("chatImages/\(UUID().uuidString).jpg")
        
        // 이미지 파일 저장
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            
            print("print 2: \(storageRef)")
            
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
                    print("저장 성공")
                    completion(.success(downloadURL))
                }
            }
        }
    }
}

