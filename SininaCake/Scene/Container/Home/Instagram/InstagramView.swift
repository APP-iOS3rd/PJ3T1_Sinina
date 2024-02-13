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
        VStack(alignment: .leading) {
            CustomText(title: "새로운 케이크", textColor: .black, textWeight: .semibold, textSize: 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(instaVM.instaData) { data in
                        AsyncImage(url: URL(string: data.mediaURL)) { image in
                            image.image?
                                .resizable()
                                .frame(width: UIScreen.UIWidth(185), 
                                       height: UIScreen.UIHeight(185) * (750/601))
                                .aspectRatio(1/1, contentMode: .fill)
                        }
                        .frame(width: UIScreen.UIWidth(185), 
                               height: UIScreen.UIHeight(185))
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
