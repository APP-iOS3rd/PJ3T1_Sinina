//
//  ProfileVIewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

import KakaoSDKUser

class ProfileViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileImageURL: URL = URL(string: "www.google.com")!
    
    init() {
        getUserInfo()
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
    
    /// 카카오 회원 탈퇴
    func handleKakaoUnlink() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
    
    /// 카카오 유저 정보 획득
    func getUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success.")
                
                self.nickname = user?.kakaoAccount?.profile?.nickname ?? "닉네임없음"
                self.profileImageURL = user?.kakaoAccount?.profile?.thumbnailImageUrl ?? URL(string: "www.google.com")!
                
            }
        }
    }
}
