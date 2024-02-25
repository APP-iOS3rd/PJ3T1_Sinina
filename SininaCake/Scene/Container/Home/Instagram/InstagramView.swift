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
    @State var sequence: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            CustomText(title: "새로운 케이크", textColor: .black, textWeight: .semibold, textSize: 24)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top) {
                    ForEach(0..<instaAPI.instaImageURLs.count, id:\.self) { i in
                        AsyncImage(url: URL(string: instaAPI.instaImageURLs[i])) { image in
                            image.image?
                                .resizable()
                                .frame(width: UIScreen.UIWidth(185), 
                                       height: UIScreen.UIHeight(185) * (750/601))
                                .aspectRatio(1/1, contentMode: .fill)
                        }
                        .onTapGesture {
                            self.sequence = i
                            isClicked.toggle()
                        }
                        .fullScreenCover(isPresented: $isClicked, content: {
                            ZStack(alignment: .topTrailing) {
                                AsyncImage(url: URL(string: instaAPI.instaImageURLs[self.sequence])) {image in
                                    image.image?.resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                }
                                
                                Button(action: {
                                    isClicked.toggle()
                                }, label: {
                                    Image("redX")
                                        .resizable()
                                        .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(24))
                                        .foregroundStyle(.red)
                                })
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(8)
                            }
                            .gesture(DragGesture(minimumDistance: 20)
                                .onEnded({ value in
                                    gesture(value: value)
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
    
    func gesture(value: DragGesture.Value) {
        // Down
        if value.translation.height > 50 {
            isClicked.toggle()
        }
        // Left
        else if value.translation.width < -50 {
            if self.sequence == instaAPI.instaImageURLs.endIndex - 1 {
                self.sequence = 0
                return
            }
            self.sequence += 1
        } 
        // Right
        else if value.translation.width > 50 {
            if self.sequence == 0 {
                self.sequence = instaAPI.instaImageURLs.endIndex - 1
                return
            }
            self.sequence -= 1
        }
    }
}

#Preview {
    InstagramView()
}
