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
    @State var imgUrl: String = ""
    @State private var dragOffset: CGFloat = 0
    
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
                            KingfisherManager.shared.retrieveImage(with: URL(string: data.mediaURL)!) { result in
                                switch result {
                                case .success(let value):
                                    imgUrl = value.source.url?.absoluteString ?? ""
                                    isClicked.toggle()
                                case .failure:
                                    break
                                }
                            }
                        }
                        .fullScreenCover(isPresented: $isClicked, content: {
                            ZStack(alignment: .topTrailing) {
                                KFImage(URL(string: imgUrl))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                
                                Button(action: {
                                    isClicked.toggle()
                                }, label: {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(24))
                                        .foregroundStyle(.red)
                                })
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(8)
                            }
                            .gesture(DragGesture(minimumDistance: 20)
                                .onEnded({ value in
                                    if value.translation.height > 100 {
                                        isClicked.toggle()
                                    }
                                })
                            )
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
