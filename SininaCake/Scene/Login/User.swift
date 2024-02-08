//
//  Users.swift
//  SininaCake
//
//  Created by 김수비 on 1/31/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User : Codable, Hashable {
    var id: String
    var name: String
    var email: String
    var createdAt: Timestamp
    
    init(name: String, email: String,
         createdAt: Timestamp = Timestamp(date: Date()),
         id: String = UUID().uuidString) {

        self.id = id
        self.name = name
        self.email = email
        self.createdAt = createdAt
    }
}


class UserStore: ObservableObject {
    static let shared = UserStore()

    private init() {}

    @Published var users = [User]()

    let db = Firestore.firestore()
    let collectionName = "Users"
    var listener: ListenerRegistration?

    // 사용자 목록
    func fetchAll() {
        db.collection(collectionName).getDocuments() { (snapshot, error) in
            guard error == nil else { return }

            // 기존 목록 비우기
            self.users.removeAll()

            // 새로운 목록으로 채우기
            for document in snapshot!.documents {
                if let data = try? document.data(as: User.self) {
                    self.users.append(data)
                    print("data", data)
                }
            }
        }

    }

    // 사용자 추가하기
    func add(user: User) {
        try? db.collection(collectionName).document(user.id).setData(from: user)
    }

    // Cloud Firestore로 실시간 업데이트 가져오기
    // 데이터베이스를 실시간으로 관찰하여 데이터 변경 여부를 확인
    func startListening() {

        listener =
        db.collection(collectionName).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot, error == nil else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    if let data = try? diff.document.data(as: User.self) {
                        self.users.append(data)
                        print("add data", data)
                    }
                }
            } // forEach
        }
    }

    // 데이터베이스를 실시간으로 관찰하는 것을 중지
    func stopListening() {
        listener?.remove()
        print("stopListening")
    }

}
