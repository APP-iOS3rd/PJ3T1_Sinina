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
    @State private var changeView = false
    @State private var showUpdate: Bool = false
    
    var body: some View {
        Image("sininaCakeImage")
            .resizable()
            .frame(width: 180, height: 180)
            .onAppear {
                Task {    
                    if await AppstoreVersionChecker.isNewVersionAvailable() {
                        showUpdate.toggle()
                    } else {
                        await splashVM.fetchUserData()
                        changeView = true
                    }
                }
            }
            .alert("새로운 버전 업데이트가 있어요", isPresented: $showUpdate) {
                Button("종료하기") {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/6476194031") {
                    Link("업데이트", destination: url)
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
