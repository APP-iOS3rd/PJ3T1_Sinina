//
//  SplashView.swift
//  SininaCake
//
//  Created by 이종원 on 1/18/24.
//

import SwiftUI

struct SplashView: View {
    @StateObject var loginVM = LoginViewModel.shared
    @State var isAutoLogin = false
    @State var changeView = false
    
    var body: some View {
        Image("sininaCakeImage")
            .resizable()
            .frame(width: 180, height: 180)
            .onAppear {
                isAutoLogin = loginVM.checkKakaoAutoLogin()
                changeView = true
            }
            .fullScreenCover(isPresented: $changeView) {
                if isAutoLogin {
                    ContainerView().environmentObject(loginVM)
                } else {
                    LoginView()
                }
            }
    }
}

#Preview {
    SplashView()
}
