//
//  HomeView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI
import KakaoSDKAuth

struct HomeView: View {
    @StateObject var loginVM: LoginViewModel = LoginViewModel()
    @State var isAuthExist = AuthApi.hasToken()
    
    var body: some View {
        CustomButton(action: {/*loginVM.handleKakaoLogout()*/}, title: "로그아웃", titleColor: UIColor.white, backgroundColor: UIColor.customBlue, leading: 12, trailing: 12)
    }
}


#Preview {
    HomeView()
}
