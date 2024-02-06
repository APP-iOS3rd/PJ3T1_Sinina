//
//  HomeView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI
import KakaoSDKAuth

struct HomeView: View {
    var body: some View {
        // TODO: MyPage로 이동 예정
        ScrollView {
            VStack {
                InstagramView()
                MapView()
            }
        }
        .padding(.bottom, 80)
    }
}


#Preview {
    HomeView()
}
