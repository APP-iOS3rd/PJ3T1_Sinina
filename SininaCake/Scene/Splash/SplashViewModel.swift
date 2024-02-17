//
//  SplashViewModel.swift
//  SininaCake
//
//  Created by 이종원 on 1/18/24.
//

import Foundation
import KakaoSDKAuth

class SplashViewModel: ObservableObject {
    private let appInfo = AppInfo.shared
    private let loginVM = LoginViewModel.shared
    
    func fetchUserData() {
        if let userInfo = appInfo.currentUser {
            print("google apple")
            loginVM.getFirebaseUserInfo(user: userInfo)
        } else if AuthApi.hasToken() {
            print("kakao")
            loginVM.getKakaoUserInfo()
        }
    }
}
