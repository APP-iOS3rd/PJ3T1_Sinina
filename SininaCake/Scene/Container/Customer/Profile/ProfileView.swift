//
//  ProfileView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var loginVM = LoginViewModel.shared
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                AsyncImage(url: URL(string: loginVM.imgURL ?? "www.google.com"))
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Text(loginVM.userName ?? "이름없음")
                
                Spacer()
            }
            .padding(16)
            
            Spacer()
            
            UnlinkButton(loginVM: loginVM)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            loginVM.getKakaoUserInfo()
        }
    }
}

struct UnlinkButton: View {
    @ObservedObject var loginVM: LoginViewModel
    @State private var showingLogout = false
    @State private var showingUnlink = false
    @State private var isNextScreenActive = false
    
    var body: some View {
        HStack {
            Button(action: { self.showingLogout.toggle() }) {
                CustomText(title: "로그아웃", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingLogout) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("로그아웃")) {
                    loginVM.handleKakaoLogout()
                    loginVM.handleFBAuthLogout()
                    
                    isNextScreenActive = true
                }
                return Alert(title: Text("로그아웃"),
                             message: Text("정말로 로그아웃 하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            
            CustomText(title: "|", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            
            Button(action: { showingUnlink = true }) {
                CustomText(title: "회원탈퇴", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingUnlink) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("회원탈퇴")) {
                    loginVM.handleKakaoUnlink()
                    loginVM.handleFBAuthUnlink()
                    
                    isNextScreenActive = true
                }
                return Alert(title: Text("회원탈퇴"),
                             message: Text("정말로 회원탈퇴 하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
        }
        .fullScreenCover(isPresented: $isNextScreenActive,
                         content: { LoginView() })
    }
}

#Preview {
    ProfileView()
}
