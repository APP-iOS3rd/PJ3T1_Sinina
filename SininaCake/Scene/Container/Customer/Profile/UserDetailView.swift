//
//  UserDetailView.swift
//  SininaCake
//
//  Created by  zoa0945 on 2/15/24.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var orderItem: OrderItem
    @State var isShowingNotification = false
    @StateObject var orderDetailVM = OrderDetailViewModel()
    
    var statusTitle: (String, UIColor, String) {
        switch orderItem.status {
        case .notAssign:
            return ("견적서", .customGray, "VectorFalse")
        case .assign:
            return ("입금 대기중", .customRed, "VectorRed")
        case .progress:
            return ("주문 확정 및 제작중", .customBlue, "VectorTrue")
        case .complete:
            return ("제작 완료", .black, "VectorFalse")
        case .pickup:
            return ("수령 완료", .black, "VectorFalse")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(statusTitle.2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(statusTitle.1))
                    CustomText(title: statusTitle.0, textColor: .black, textWeight: .semibold, textSize: 18)
                    Spacer()
                }
                .padding(.leading, 24)
                .padding(.top, 40)
                
                Spacer()
                    .frame(height: 42)
                
                OrderInfoView(orderItem: $orderItem)
                
                DividerView()
                
                CakeInfoView(orderItem: $orderItem)
                
                Spacer()
                    .frame(height: 18)
                
                PhotoView(orderItem: $orderItem, orderDetailVM: orderDetailVM)
                
                Spacer()
                    .frame(height: 32)
                
                EtcView(orderItem: $orderItem)
                
                DividerView()
                
                UserPriceView(orderItem: $orderItem, isShowingNotification: $isShowingNotification)
                
                NotificationView(isShowing: $isShowingNotification)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("주문현황")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    Image("angle-left")
                        .foregroundStyle(Color.black)
                })
            }
        }
        .onAppear {
            orderDetailVM.downloadImageURL(orderItem.id, orderItem.imageURL)
        }
    }
}

struct NotificationView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.customGray))
                .frame(width: UIScreen.main.bounds.width - 48, height: 40)
                .overlay(
                    HStack {
                        CustomText(title: "계좌번호가 복사되었습니다.", textColor: .white, textWeight: .semibold, textSize: 16)
                        Spacer()
                    }
                        .padding(.horizontal, 12)
                )
            
        }
        .opacity(isShowing ? 1 : 0)
        .background(Color(.clear))
        .animation(.easeInOut)
    }
}

// MARK: - UserPriceView
struct UserPriceView: View {
    @Binding var orderItem: OrderItem
    @Binding var isShowingNotification: Bool
    let accountNumber = "신한 110 544 626471"
    
    var priceText: (String, String) {
        switch orderItem.status {
        case .notAssign:
            return ("총 예상금액", intToString(orderItem.expectedPrice))
        default:
            return ("총 확정금액", intToString(orderItem.confirmedPrice))
        }
    }
    
    var accountOpacity: Double {
        switch orderItem.status {
        case .notAssign, .complete, .pickup:
            return 0
        case .assign, .progress:
            return 1
        }
    }
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                CustomText(title: priceText.0, textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 45)
                CustomText(title: priceText.1, textColor: .black, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            
            HStack {
                CustomText(title: "계좌번호", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 63)
//                CustomText(title: accountNumber, textColor: .black, textWeight: .semibold, textSize: 16)
                Button(action: {
                    UIPasteboard.general.string = accountNumber
                    withAnimation {
                        isShowingNotification.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isShowingNotification.toggle()
                        }
                    }
                }) {
                    CustomText(title: accountNumber, textColor: .black, textWeight: .semibold, textSize: 16)
                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(.black))
                }
                Spacer()
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .opacity(accountOpacity)
        }
    }
}

// MARK: - Convert Method
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

private func stringToInt(_ str: String) -> Int {
    let numbers = "0123456789"
    var result = ""
    
    for number in str {
        if numbers.contains(number) {
            result += String(number)
        }
    }
    
    return Int(result) ?? 0
}
