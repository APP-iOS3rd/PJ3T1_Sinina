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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    static let shared = LoginViewModel()
    @Published var isLoggedin: Bool = false
    
    @Published var loginUserEmail: String?
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
                    self.getKakaoUserInfo()
                    self.isLoggedin = true
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    self.getKakaoUserInfo()
                    self.isLoggedin = true
                }
            }
        }
    }
    
    /// 카카오 유저 정보 획득
    func getKakaoUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                let email = user?.kakaoAccount?.email ?? ""
                let imgURL = user?.kakaoAccount?.profile?.thumbnailImageUrl?.absoluteString ?? ""
                let userName = user?.kakaoAccount?.profile?.nickname ?? ""
                
                self.loginUserEmail = email
                self.imgURL = imgURL
                self.userName = userName
                
                self.storeUserInfo(email: email,
                                   imgURL: imgURL,
                                   userName: userName)
            }
        }
    }
    
    /// 유저 정보 저장
    func storeUserInfo(email: String, imgURL: String, userName: String) {
        guard let deviceToken = AppInfo.shared.deviceToken else {
            return
        }
        
        Task {
            await self.addUserInfoToFirestore(email: email,
                                              imgURL: imgURL,
                                              userName: userName,
                                              deviceToken: deviceToken)
        }
    }
    
    /// 카카오 자동 로그인
    func checkKakaoAutoLogin() -> Bool {
        var isAutoLogin = false

        return isAutoLogin
    }
//        if (AuthApi.hasToken()) {
//            UserApi.shared.accessTokenInfo { (_, error) in
//                if let error = error {
//                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
//                        //로그인 필요
//                        return
//                    }
//                    else {
//                        //기타 에러
//                        return
//                    }
//                }
//                else {
//                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
//                    isAutoLogin = true
//                    return
//                }
//            }
//        }
//        else {
//            //로그인 필요
//            return false
//        }
//        return isAutoLogin
//    }
}

// MARK: - 파이어베이스 제공 간편 로그인
extension LoginViewModel {
    func signInFirebase(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else { return }
            self.loginUserEmail = user.email
            print("로그인한 사람: \(self.loginUserEmail)")
            AppInfo.shared.currentUser = user
            let userInfo = self.getFirebaseUserInfo(user: user)
            print("errrrrror \(userInfo.0) -- \(userInfo.1), \(userInfo.2)")
            self.storeUserInfo(email: userInfo.0,
                               imgURL: userInfo.1,
                               userName: userInfo.2)
            self.isLoggedin = true
        }
    }
    
    // FIXME: - 회원가입일때만 저장
    /// 유저 정보 파이어스토어에 저장
    func addUserInfoToFirestore(email: String, imgURL: String, userName: String, deviceToken: String) async {
        let db = Firestore.firestore()
        
        do {
          try await db.collection("Users").document(email).setData([
            "email": email,
            "userName": userName,
            "imgURL": imgURL,
            "deviceToken": deviceToken
          ], merge: true)
          print("Document successfully written!")
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    // MARK: - 파이어베이스
    /// 파이어베이스 유저 정보 획득
    func getFirebaseUserInfo(user: FirebaseAuth.User) -> (String, String, String) {
        let email = user.email ?? ""
        let imgURL = user.photoURL?.absoluteString ?? ""
        let userName = user.displayName ?? ""
        
        // TODO: - 함수로 축약
        self.loginUserEmail = email
        self.imgURL = imgURL
        self.userName = userName
        return (email, imgURL, userName)
    }
}

// MARK: - 로그아웃, 회원탈퇴
extension LoginViewModel {
    /// 카카오 로그아웃
    func handleKakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
        isLoggedin = false
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
        isLoggedin = false
    }
    
    /// 파이어베이스 Auth 로그아웃
    func handleFBAuthLogout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        isLoggedin = false
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
        isLoggedin = false
    }
}
