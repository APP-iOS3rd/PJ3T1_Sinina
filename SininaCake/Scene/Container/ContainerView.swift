//
//  ContainerView.swift
//  SininaCake
//
//  Created by 이종원 on 2/6/24.
//

import SwiftUI
import Firebase

struct ContainerView: View {
    @State var currentTab: Tab = .home
    @ObservedObject var loginVM = LoginViewModel.shared
    @ObservedObject var chatVM = ChatViewModel.shared
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                // FIXME: - ChatView() 파라미터 전달
//                ChatListView(loginUserEmail: loginVM.loginUserEmail)
                
                // FIXME: 여기서 room에 새로운 uuid가 들어가는 것이 아니라, 해당 유저의 채팅방으로 들어가줘야함
                // 해당 유저의 uuid를 찾아 여기서 넣어줘야함
                // uuid를 사용하지 않고 고유값을 이메일로 해보자
                ChatView2(loginUserEmail: loginVM.loginUserEmail, room: ChatRoom(userEmail: loginVM.loginUserEmail ?? ""))
                
                HomeView()
                    .tag(Tab.home)
                ProfileView()
                    .tag(Tab.profile)
            }
            .padding(.bottom, 60)
       
            CustomTabView(selection: $currentTab)
        }
    }
}

enum Tab: String, CaseIterable {
    case chat = "icon_chat"
    case home = "icon_home"
    case profile = "icon_profile"
}

func getTab(tab: Tab) -> String {
    switch tab {
    case .chat:
        return "icon_selected_chat"
    case .home:
        return "icon_selected_home"
    case .profile:
        return "icon_selected_profile"
    }
}

struct CustomTabView: View {
    @Binding var selection: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button {
                    selection = tab
                } label: {
                    Image(selection != tab ? tab.rawValue : getTab(tab: tab))
                        .frame(width: 120, height: UIScreen.main.bounds.size.height * (50/932))
                        .contentShape(Rectangle())
                        .scaleEffect(selection == tab ? 1.1 : 0.9)
                }
                .buttonStyle(TabButtonStyle())
            }
        }
        .padding(.top, 20)
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    ContainerView()
}
