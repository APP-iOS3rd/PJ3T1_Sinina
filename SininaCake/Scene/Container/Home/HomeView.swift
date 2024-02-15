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
    @State private var showManager = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack {
                    OrderStatusView()
                    InstagramView()
                    MapView()
                }
            }
            .background(Color(.customLightGray))
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
                        showManager = true
                    } label: {
                        //                        if (loginVM.email == "jongwon5113@gmail.com") {
                        Image("icon_manager")
                        //                        }
                    }
                    //                    .disabled(loginVM.email != "jongwon5113@gmail.com")
                    .fullScreenCover(isPresented: $showManager) {
                        ManagerOnlyView()
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
