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
    
    func fetchUserData() async {
        if let userInfo = appInfo.currentUser {
            print("google apple")
            loginVM.getFirebaseUserInfo(user: userInfo)
            await loginVM.checkManager(email: appInfo.currentUser?.email ?? "")
        } else if AuthApi.hasToken() {
            print("kakao")
            loginVM.getKakaoUserInfo()
        }
    }
}
