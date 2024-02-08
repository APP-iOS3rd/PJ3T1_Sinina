//
//  FCMServerAPI.swift
//  SininaCake
//
//  Created by  zoa0945 on 2/7/24.
//

import Foundation
import Firebase

class AppInfo {
    static let shared = AppInfo()
    
    var deviceToken: String? = nil
}

class FCMServerAPI: ObservableObject {
    func sendFCM(deviceToken: String, body: String) {
        guard let fcmServerURL = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            print("Cannot Found Server URL")
            return
        }
        
        guard let infoDic = Bundle.main.infoDictionary else {
            return
        }
        
        let serverKey = infoDic["FCM_SERVER_KEY"] as! String
        print("Key: \(serverKey)")
        
        var request = URLRequest(url: fcmServerURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let message: [String: Any] = [
            "to": deviceToken,
            "notification": [
                "title": "시니나케이크",
                "body": body
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: message)
        } catch let error {
            print("Encoding Error: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("URLSession Error: \(error.localizedDescription)")
                return
            }
            
            print("Send Message Successfully")
        }
        
        task.resume()
    }
}
