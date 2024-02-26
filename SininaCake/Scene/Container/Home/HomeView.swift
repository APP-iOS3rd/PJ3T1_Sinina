//
//  HomeView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    @StateObject var orderStatusVM = OrderStatusViewModel()
    @ObservedObject var loginVM = LoginViewModel.shared
//    @State private var showManager = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 64) {
                    OrderStatusView(orderStatusVM: orderStatusVM)
                    HomeCalendarView()
                    InstagramView()
                    MapView()
                    Spacer()
                }
            }
            .background(Color(.customLightGray))
            .refreshable {
                orderStatusVM.fetchData()
            }
        }
    }
}
