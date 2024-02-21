//
//  SplashView.swift
//  SininaCake
//
//  Created by 이종원 on 1/18/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

struct SplashView: View {
    @StateObject var loginVM = LoginViewModel.shared
    @StateObject var splashVM = SplashViewModel()
    @State var changeView = false
    
    var body: some View {
        Image("sininaCakeImage")
            .resizable()
            .frame(width: 180, height: 180)
            .onAppear {
                Task {
                    await splashVM.fetchUserData()
                    changeView = true
                }
            }
            .fullScreenCover(isPresented: $changeView) {
                if loginVM.loginUserEmail != nil {
                    ContainerView().environmentObject(loginVM)
                } else {
                    LoginView().onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            AuthController.handleOpenUrl(url: url)
                        }
                    })
                }
            }
    }
}

#Preview {
    SplashView()
}
