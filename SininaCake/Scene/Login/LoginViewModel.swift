//
//  LoginViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import KakaoSDKUser

class LoginViewModel: ObservableObject {
    @Published var isLoggedin: Bool = false
    
    /// 카카오 로그인
    func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    self.getUserInfo()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    self.getUserInfo()
                }
            }
        }
    }
    
    /// 카카오 로그아웃
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
    
    func getUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success.")
                
                //do something
                let userNickName = user?.kakaoAccount?.profile?.nickname
                let userThumnail = user?.kakaoAccount?.profile?.thumbnailImageUrl
                
                self.isLoggedin = true
            }
        }
    }
    
}

