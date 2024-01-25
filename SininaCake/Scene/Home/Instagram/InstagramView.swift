//
//  InstagramView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI

struct InstagramView: View {
    @StateObject var instaVM = InstagramViewModel()
    //private var instaData: [InstaData]
    
    var body: some View {
        VStack {
            
            // FIXME: - 고치기!
            Text("🧁 새로운 케이크")
                .font(
                    Font.custom("Pretendard", size: 24)
                        .weight(.semibold)
                )
                .kerning(0.6)
                .foregroundColor(.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(instaVM.instaData) { data in
                        AsyncImage(url: URL(string: data.mediaURL)) { image in
                            image.image?
                                .resizable()
                                .frame(width: 185, height: 185 * (750/601))
                                .aspectRatio(1/1, contentMode: .fill)
                        }
                        .frame(width: 185, height: 185)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                }
                .frame(height: 200)
            }
        }
        .padding(.horizontal, 12)
        .onAppear() {
            instaVM.fetchInstaData()
        }
    }
}

#Preview {
    InstagramView()
}
