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
                                    Text("Username")
                                    Text("Message sent to user")
                                }
                                Spacer()
                                
                                Text("22d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                        }.padding(.horizontal)
                        
                    }
                }.navigationTitle("시니나케이크")
            }
        }
        
    }
}

#Preview {
    ChatListView()
}
