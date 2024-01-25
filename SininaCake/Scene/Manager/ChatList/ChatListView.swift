//
//  ChatListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(0..<10, id: \.self){ num in
                        VStack {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                VStack(alignment: .leading) {
                                    Text("이찰떡")
                                    Text("케이크 관련 문의드립니다!")
                                        .foregroundStyle(Color.init(UIColor.customGray))
                                }
                                Spacer()
                                
                                Text("오후 1:05")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.init(UIColor.customGray))
                            }
                            Divider()
                        }.padding(.horizontal)
                        
                    }
                }
                .navigationTitle("💬 채팅방")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
    }
}

#Preview {
    ChatListView()
}
