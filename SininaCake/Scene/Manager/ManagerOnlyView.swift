//
//  ManagerOnlyView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI

enum ManagerTab: String, CaseIterable {
    case list = "icon_list"
    case calendar = "icon_calendar"
    case chat = "icon_chat"
}

func getManagerTab(tab: ManagerTab) -> String {
    switch tab {
    case .list:
        return "icon_selected_list"
    case .calendar:
        return "icon_selected_calendar"
    case .chat:
        return "icon_selected_chat"
    }
}

struct ManagerOnlyView: View {
    @State var currentTab: ManagerTab = .list
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTab) {
                OrderListView()
                    .tag(ManagerTab.list)
                CalendarView()
                    .tag(ManagerTab.calendar)
                ChatListView()
                    .tag(ManagerTab.chat)
            }
            .padding(.top, 60)
            
            ManagerTabView(selection: $currentTab)
        }
    }
}

struct ManagerTabView: View {
    @Binding var selection: ManagerTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ManagerTab.allCases, id: \.rawValue) { tab in
                Button {
                    selection = tab
                } label: {
                    VStack {
                        Image(selection != tab ? tab.rawValue : getManagerTab(tab: tab))
                            .frame(width: 120, height: UIScreen.main.bounds.size.height * (50/932))
                            .contentShape(Rectangle())
                            .scaleEffect(selection == tab ? 1.1 : 0.9)
                        
                        Divider()
                            .frame(minHeight: 2)
                            .overlay(selection == tab ? Color(UIColor.customBlue) : Color(UIColor.customLightGray))
                    }
                    .buttonStyle(TabButtonStyle())
                    .background(.white)
                }
            }
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    ManagerOnlyView()
}
