//
//  LoginView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var LoginVM = LoginViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("sininaCakeImage")
                .resizable()
                .frame(width: 120, height: 120)
            
            Spacer()
            
            HStack {
                CustomText(
                    title: "🍰 로그인하기",
                    textColor: .black,
                    textWeight: .semibold,
                    textSize: 24
                )
                
                Spacer()
            }
            .padding(.leading, 42)
            
            Spacer()
                .frame(height: 32)
            
            LoginButtonView(viewModel: LoginVM)
            
            Spacer()
                .frame(height: 70)
        }
    }
}

struct LoginButtonView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 18) {
            // 카카오 로그인 버튼
            Button(action: {}, label: {
                Image("kakaoLogin")
                    .resizable()
                    .scaledToFit()
            })
            .padding(.leading, 24)
            .padding(.trailing, 24)
            
            // 구글 로그인 버튼
            Button(action: {}, label: {
                Image("googleLogin")
                    .resizable()
                    .scaledToFit()
            })
            .padding(.leading, 24)
            .padding(.trailing, 24)
            
            // 애플 로그인 버튼
            Button(action: viewModel.startSignInWithAppleFlow, label: {
                Image("appleLogin")
                    .resizable()
                    .scaledToFit()
            })
            .padding(.leading, 24)
            .padding(.trailing, 24)
        }
    }
}

#Preview {
    LoginView()
}
