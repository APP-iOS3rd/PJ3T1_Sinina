//
//  LoginViewModel.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import KakaoSDKUser

class LoginViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    static let shared = LoginViewModel()
    @Published var isLoggedin: Bool = false
    
    @Published var email: String?
    @Published var imgURL: String?
    @Published var userName: String?
    
    var currentNonce: String?
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // MARK: - 애플 로그인
    /// 애플 로그인
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            
            self.signInFirebase(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

// MARK: - 구글 로그인
extension LoginViewModel {
    /// 구글 로그인
    func handleGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: Utilities.rootViewController) { result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            self.signInFirebase(credential: credential)
        }
    }
}

// MARK: - 카카오 로그인
extension LoginViewModel {
    /// 카카오 로그인
    func handleKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    self.isLoggedin = true
                    self.getAndStoreKakaoUserInfo()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    self.isLoggedin = true
                    self.getAndStoreKakaoUserInfo()
                }
            }
        }
    }
    
    // MARK: - 카카오 유저 정보 획득
    func getAndStoreKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                let email = user?.kakaoAccount?.email ?? ""
                let imgURL = user?.kakaoAccount?.profile?.thumbnailImageUrl?.absoluteString ?? ""
                let userName = user?.kakaoAccount?.profile?.nickname ?? ""
                
                // TODO: - 함수로 축약
                self.email = email
                self.imgURL = imgURL
                self.userName = userName
                
                Task {
                    await self.addUserInfoToFirestore(email: email, imgURL: imgURL, userName: userName)
                }
            }
        }
    }
}

// MARK: - 파이어베이스 저장
extension LoginViewModel {
    func signInFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            print(user)
            self.isLoggedin = true
            self.getAndStoreFirebaseUserInfo(user: user)
        }
    }
    
    func getAndStoreFirebaseUserInfo(user: FirebaseAuth.User) {
        // FIXME: - 로그인 할때마다 사용자를 저장하게 됨
        let email = user.email ?? ""
        let imgURL = user.photoURL?.absoluteString ?? ""
        let userName = user.displayName ?? ""
        
        // TODO: - 함수로 축약
        self.email = email
        self.imgURL = imgURL
        self.userName = userName
        
        Task {
            await self.addUserInfoToFirestore(email: email, imgURL: imgURL, userName: userName)
        }
    }
    
    // MARK: - 유저 정보 파이어스토어에 저장
    // FIXME: - 회원가입일때만 저장
    func addUserInfoToFirestore(email: String, imgURL: String, userName: String) async {
        let db = Firestore.firestore()
        
        do {
          try await db.collection("Users").document(email).setData([
            "email": email,
            "userName": userName,
            "imgURL": imgURL
          ], merge: true)
          print("Document successfully written!")
        } catch {
          print("Error writing document: \(error)")
        }
    }
}
