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
    func sendFCM() {
        let fcmServerURL = URL(string: "https://fcm.googleapis.com/fcm/send")!
        
        guard let infoDic = Bundle.main.infoDictionary else {
            return
        }
        
        guard let deviceToken = AppInfo.shared.deviceToken else {
            print("Cannot Found Device Token")
            return
        }
        
        let serverKey = "AAAALcAFAJA:APA91bEfcDGaylY9yGXGCmT4zWqUzAM7FQs-4Ds9yk8vDQfoUEnsY6dtAhv5HUw_yXd_TaFl8iPjer8fMopTUR6MFhSXGM4RrDcYPg-IZ2IyxMnp5QJfxwq8vFShupkpu6ft4F9X9zGk"
//        String(describing: infoDic["FCM_SERVER_KEY"])
        
        var request = URLRequest(url: fcmServerURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let message: [String: Any] = [
            "to": deviceToken,
            "notification": [
                "title": "Test",
                "body": "Test Message"
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
