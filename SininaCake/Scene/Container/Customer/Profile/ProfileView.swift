//
//  ProfileView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                AsyncImage(url: profileVM.profileImageURL)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Text(profileVM.nickname)
                
                Spacer()
            }
            .padding(16)
            
            Spacer()
            
            AccountButton(profileVM: profileVM)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
}

struct AccountButton: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var showingLogout = false
    @State private var showingUnlink = false
    @State private var isNextScreenActive = false
    
    var body: some View {
        HStack {
            Button(action: { self.showingLogout.toggle() }) {
                CustomText(title: "로그아웃", textColor: .customGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingLogout) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("로그아웃")) {
                    profileVM.handleKakaoLogout()
                    profileVM.handleFBAuthLogout()
                    
                    isNextScreenActive = true
                }
                return Alert(title: Text("로그아웃"),
                             message: Text("정말로 로그아웃 하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            
            CustomText(title: "|", textColor: .customGray, textWeight: .semibold, textSize: 16)
            
            Button(action: { showingUnlink = true }) {
                CustomText(title: "회원탈퇴", textColor: .customGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingUnlink) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("회원탈퇴")) {
                    profileVM.handleKakaoUnlink()
                    profileVM.handleFBAuthUnlink()
                    
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
