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
    @State private var showManager = false
    @State private var showNavManager = false
    @ObservedObject var loginVM = LoginViewModel.shared
    @ObservedObject var chatVM = ChatViewModel.shared
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $currentTab) {
                    HomeView()
                        .tag(Tab.home)
                    
                    ProfileView()
                        .tag(Tab.profile)
                }
                .padding(.bottom, 90)
                
                CustomTabView(selection: $currentTab)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.white, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                        Image("sininaCakeLogo")
                            .resizable()
                            .frame(width: UIScreen.UIWidth(40),
                                   height: UIScreen.UIHeight(40))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Trailing item if needed
                    Button {
                        showNavManager = true
                    } label: {
                        //                        if (loginVM.email == "jongwon5113@gmail.com") {
                        Image("icon_manager")
                        //                        }
                    }
                    //                    .disabled(loginVM.email != "jongwon5113@gmail.com")
                    .fullScreenCover(isPresented: $showNavManager) {
                        ManagerOnlyView()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showManager, content: {
            ChatView2(loginUserEmail: loginVM.loginUserEmail, room: ChatRoom(userEmail: loginVM.loginUserEmail ?? "", id: loginVM.loginUserEmail ?? ""))
                .onDisappear() {
                    currentTab = .home
                }
        })
        .onChange(of: currentTab) { newValue in
            if newValue == .chat {
                showManager = true
            } else {
                showManager = false
            }
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

struct OrderButtonView: View {
    var body: some View {
        NavigationLink(destination: CautionView()) {
            HStack {
                Spacer()
                CustomText(title: "주문하기", textColor: .white, textWeight: .semibold, textSize: 18)
                    .frame(minHeight: 55)
                Spacer()
            }
            .background(Color(.customBlue))
            .cornerRadius(27.5)
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 12)
        }
    }
}

struct CustomTabView: View {
    @Binding var selection: Tab
    
    var body: some View {
        VStack(spacing: -10) {
            if selection == .home {
                OrderButtonView()
                    .background(Color(.white))
            }
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        selection = tab
                    } label: {
                        Image(selection != tab ? tab.rawValue : getTab(tab: tab))
                            .frame(width: UIScreen.UIWidth(120), height: UIScreen.UIHeight(50))
                            .contentShape(Rectangle())
                            .scaleEffect(selection == tab ? 1.1 : 0.9)
                    }
                    .buttonStyle(TabButtonStyle())
                }
            }
            .padding(.top, 20)
        }
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}
