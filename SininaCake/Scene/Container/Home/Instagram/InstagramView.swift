//
//  InstagramView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI
import Kingfisher

struct InstagramView: View {
    @StateObject var instaAPI = InstagramAPI()
    @State var isClicked = false
    @State var imgUrl: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            CustomText(title: "새로운 케이크", textColor: .black, textWeight: .semibold, textSize: 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(instaAPI.instaData) { data in
                        AsyncImage(url: URL(string: data.mediaURL)) { image in
                            image.image?
                                .resizable()
                                .frame(width: UIScreen.UIWidth(185), 
                                       height: UIScreen.UIHeight(185) * (750/601))
                                .aspectRatio(1/1, contentMode: .fill)
                        }
                        .onTapGesture {
                            imgUrl = data.mediaURL
                            isClicked.toggle()
                        }
                        .fullScreenCover(isPresented: $isClicked, content: {
                            VStack(alignment: .trailing) {
                                Button(action: {
                                    isClicked.toggle()
                                }, label: {
                                    Text("닫기")
                                })
                            
                                KFImage(URL(string: imgUrl ?? data.mediaURL))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        })
                        .frame(width: UIScreen.UIWidth(185),
                               height: UIScreen.UIHeight(185))
                        .clipShape(.rect(cornerRadius: 12))
                    }
                }
                .frame(height: 185)
            }
        }
        .padding(.horizontal, 24)
        .onAppear() {
            instaAPI.fetchInstaData()
        }
    }
}

#Preview {
    InstagramView()
}
