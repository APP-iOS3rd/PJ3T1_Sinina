//
//  HomeView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    @ObservedObject var loginVM = LoginViewModel.shared
//    @State private var showManager = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 64) {
                    OrderStatusView()
                    HomeCalendarView()
                    InstagramView()
                    MapView()
                    Spacer()
                }
            }
            .background(Color(.customLightGray))
        }
    }
}
