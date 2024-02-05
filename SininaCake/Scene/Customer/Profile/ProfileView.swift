//
//  ProfileView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileVM = ProfileViewModel()
    
    
    var body: some View {
        VStack {
            AsyncImage(url: profileVM.profileImageURL)
                .frame(width: 100, height: 100)
            
            Text(profileVM.nickname)
            
            Spacer()
            
            AccountButton(profileVM: profileVM)
        }
    }
}

struct AccountButton: View {
    @State private var showing = false
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        HStack {
            Button(action: {showing = true}) {
                CustomText(title: "로그아웃", textColor: .customGray, textWeight: .semibold, textSize: 16)
            }
            .alert("로그아웃 하기", isPresented: $showing) {
                Button ("아니오", role: .cancel) { }
                Button("네") { profileVM.handleKakaoLogout() }
            }
            
            CustomText(title: "|", textColor: .customGray, textWeight: .semibold, textSize: 16)
            
            Button(action: {showing = true}) {
                CustomText(title: "회원탈퇴", textColor: .customGray, textWeight: .semibold, textSize: 16)
            }
            .alert("회원탈퇴 하기", isPresented: $showing) {
                Button ("아니오", role: .cancel) { }
                Button("네") { profileVM.handleKakaoUnlink() }
            }
        }
    }
}

#Preview {
    ProfileView()
}
