//
//  HomeView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI
import KakaoSDKAuth

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    
    var body: some View {
        // TODO: MyPage로 이동 예정
        VStack {
            /*NavigationStack {
                NavigationLink (destination: LoginView()) {
                    CustomButton(action: { homeVM.handleKakaoLogout() }, title: "로그아웃", titleColor: UIColor.white, backgroundColor: UIColor.customBlue, leading: 12, trailing: 12)
                }
            }*/
            
            InstagramView()
            
            AsyncImage(url: homeVM.profileImageURL)
                .frame(width: 200, height: 200)
            
            Text(homeVM.nickname)
        }
    }
}


#Preview {
    HomeView()
}
