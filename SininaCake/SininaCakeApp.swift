//
//  SininaCakeApp.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}

@main
struct SininaCakeApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // Kakao SDK 초기화
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        print("TOKEN: \(kakaoAppKey)")
    }
    
    var body: some Scene {
        WindowGroup {
            
            //ChatView(userEmail: ")
            ChatListView(loginedUser: User(name: "아무개", email: "k@gmail.com", createdAt: Timestamp(date: Date()), id: "KYhEjCvYERI4CyoGlZPu"))
            //ChatView(chatUser: "사용자이름")
//            LoginView().onOpenURL(perform: { url in
//                if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                    AuthController.handleOpenUrl(url: url)
//                }
//            })
        }
    }
}
