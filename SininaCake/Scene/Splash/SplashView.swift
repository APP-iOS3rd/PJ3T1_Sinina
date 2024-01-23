//
//  SplashView.swift
//  SininaCake
//
//  Created by 이종원 on 1/18/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("sininaCakeImage")
            .resizable()
            .frame(width: 180, height: 180)
    }
}

#Preview {
    SplashView()
}
