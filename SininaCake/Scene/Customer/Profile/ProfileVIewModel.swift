//
//  ProfileVIewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation

import FirebaseAuth
import KakaoSDKUser

class ProfileViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var profileImageURL: URL = URL(string: "www.google.com")
    
    init() {
        getKakaoUserInfo()
        getFBAuthUserInfo()
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
        handleFBAuthLogout()
    }
    
    /// 파이어베이스 Auth 로그아웃
    func handleFBAuthLogout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
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
        handleFBAuthUnlink()
    }
    
    /// 파이어베이스 Auth 회원 탈퇴
    func handleFBAuthUnlink() {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                // An error happened.
            } else {
                // Account deleted.
            }
        }
    }
    
    /// 카카오 유저 정보 획득
    func getKakaoUserInfo() {
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
    
    /// 파이어베이스 유저 정보 획득
    func getFBAuthUserInfo() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                self.nickname = user?.displayName ?? "닉네임없음"
                self.profileImageURL = user?.photoURL ?? URL(string: "www.google.com")!
            }
        }
    }
}
