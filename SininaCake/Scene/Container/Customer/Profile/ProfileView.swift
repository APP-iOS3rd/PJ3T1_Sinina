//
//  ProfileView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var loginVM = LoginViewModel.shared
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                ImageAndNameView(profileVM: profileVM)
                
                ScrollView {
                    MyOrderListView(profileVM: profileVM)
                }
                
                Spacer()
                
                UnlinkButton(loginVM: loginVM)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: OrderItem.self, destination: { item in
                UserDetailView(orderItem: item)
            })
            .onAppear {
                loginVM.getKakaoUserInfo()
                profileVM.downloadProfileImage()
            }
        }
    }
}

struct ImageAndNameView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    var title: String {
        switch profileVM.loginVM.userName {
        case "", nil:
            return "닉네임없음"
        default:
            return profileVM.loginVM.userName ?? ""
        }
    }
    
    var body: some View {
        HStack {
            if let image = profileVM.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Image("icon_profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
            
            Spacer()
                .frame(width: 18)
            
            CustomText(title: title, textColor: .black, textWeight: .semibold, textSize: 18)
            
            Spacer()
        }
        .padding(.leading, 24)
        .padding(.top, 24)
    }
}

struct MyOrderListView: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                CustomText(title: "MY", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                CustomText(title: "주문내역", textColor: .black, textWeight: .semibold, textSize: 18)
                Spacer()
            }
            
            if profileVM.myOrderData.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.customGray))
                    .frame(height: 100)
                    .overlay(
                        VStack {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color(.customGray))
                                .frame(width: 20, height: 20)
                            CustomText(title: "주문 내역이 없습니다.", textColor: .customGray, textWeight: .semibold, textSize: 16)
                        }
                    )
            } else {
                ForEach(0..<profileVM.myOrderData.count, id: \.self) { i in
                    NavigationLink(value: profileVM.myOrderData[i]) {
                        MyOrderView(profileVM: profileVM, orderItem: profileVM.myOrderData[i])
                    }
                }
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 32)
    }
}

struct MyOrderView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State var thumbnailImage: UIImage? = nil
    let orderItem: OrderItem
    
    var body: some View {
        VStack {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 96, height: UIScreen.main.bounds.width / 2)
                    .clipped()
            } else {
                Image("emptyPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 96, height: UIScreen.main.bounds.width / 2)
                    .clipped()
            }
            InfoView(orderItem: orderItem)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.customGray))
        )
        .overlay(
            VStack {
                HStack {
                    StatusTextView(orderItem: orderItem)
                    Spacer()
                }
                Spacer()
            }
        )
        .onAppear {
            if !orderItem.imageURL.isEmpty && orderItem.imageURL[0] != "" {
                profileVM.downloadImage(orderItem.id, orderItem.imageURL[0]) { image in
                    DispatchQueue.main.async {
                        self.thumbnailImage = image
                    }
                }
            }
        }
    }
}

struct StatusTextView: View {
    let orderItem: OrderItem
    
    var titleAndColor: (String, UIColor, UIColor) {
        switch orderItem.status {
        case .assign:
            return ("예약완료", .white, .customBlue)
        case .notAssign:
            return ("예약대기", .customDarkGray, .customGray)
        case .complete:
            return ("제작완료", .black, .customGray)
        }
    }
    
    var body: some View {
        CustomText(title: titleAndColor.0, textColor: titleAndColor.1, textWeight: .semibold, textSize: 14)
            .frame(width: UIScreen.UIWidth(75), height: UIScreen.UIHeight(30))
            .background(Color(titleAndColor.2))
            .cornerRadius(15)
            .padding()
    }
}

struct InfoView: View {
    let orderItem: OrderItem
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                CustomText(title: orderItem.date.dateToString(), textColor: .black, textWeight: .semibold, textSize: 18)
                Spacer()
                Image(systemName: "clock")
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(.customBlue))
                CustomText(title: orderItem.date.dateToTime(), textColor: .customBlue, textWeight: .semibold, textSize: 18)
            }
            
            HStack {
                CustomText(title: orderItem.cakeSize, textColor: .black, textWeight: .semibold, textSize: 18)
                CustomText(title: "\(orderItem.sheet) / \(orderItem.cream)", textColor: .customGray, textWeight: .regular, textSize: 16)
                Spacer()
                CustomText(title: intToString(orderItem.confirmedPrice), textColor: .black, textWeight: .semibold, textSize: 18)
            }
        }
        .background(Color(.white))
        .padding(24)
        .clipShape(
            .rect(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
        )
    }
}

struct UnlinkButton: View {
    @ObservedObject var loginVM: LoginViewModel
    @State private var showingLogout = false
    @State private var showingUnlink = false
    @State private var isNextScreenActive = false
    let appInfo = AppInfo.shared
    
    var body: some View {
        HStack {
            Button(action: { self.showingLogout.toggle() }) {
                CustomText(title: "로그아웃", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingLogout) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("로그아웃")) {
                    loginVM.loginUserEmail = nil
                    loginVM.userName = nil
                    loginVM.imgURL = nil
                    appInfo.currentUser = nil
                    
                    loginVM.handleKakaoLogout()
                    loginVM.handleFBAuthLogout()
                    
                    isNextScreenActive = true
                }
                return Alert(title: Text("로그아웃"),
                             message: Text("정말로 로그아웃 하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
            
            CustomText(title: "|", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            
            Button(action: { showingUnlink = true }) {
                CustomText(title: "회원탈퇴", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            .alert(isPresented: $showingUnlink) {
                let firstButton = Alert.Button.cancel(Text("취소")) {

                }
                let secondButton = Alert.Button.destructive(Text("회원탈퇴")) {
                    loginVM.handleKakaoUnlink()
                    loginVM.handleFBAuthUnlink()
                    
                    loginVM.loginUserEmail = nil
                    loginVM.userName = nil
                    loginVM.imgURL = nil
                    appInfo.currentUser = nil
                    
                    isNextScreenActive = true
                }
                return Alert(title: Text("회원탈퇴"),
                             message: Text("정말로 회원탈퇴 하시겠습니까?"),
                             primaryButton: firstButton, secondaryButton: secondButton)
            }
        }
        .fullScreenCover(isPresented: $isNextScreenActive,
                         content: { LoginView() })
    }
}

private func intToString(_ price: Int) -> String {
    let priceString = String(price)
    var result = ""
    var count = 0
    
    for str in priceString.reversed() {
        result += String(str)
        count += 1
        if count % 3 == 0 && count != priceString.count {
            result += ","
        }
    }
    
    return result.reversed() + "원"
}
