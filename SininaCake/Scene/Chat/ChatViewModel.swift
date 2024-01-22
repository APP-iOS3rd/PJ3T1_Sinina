//
//  ChatViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var chatText = ""
    
    init() {
        
    }
    
    func handleSend() {
        print(chatText)
        
        guard let fromId =
                FirebaseManager.shared.auth.currentUser?.uid
                else { return }
        
        guard let toId
         
    }
}
