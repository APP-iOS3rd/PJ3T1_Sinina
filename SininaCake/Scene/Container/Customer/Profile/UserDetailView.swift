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
    @StateObject var orderDetailVM = OrderDetailViewModel()
    
    var statusTitle: (String, UIColor, String) {
        switch orderItem.status {
        case .assign:
            return ("승인 주문건 현황", .customBlue, "VectorTrue")
        case .notAssign:
            return ("미승인 주문건 현황", .customGray, "VectorFalse")
        case .complete:
            return ("완료 주문건 현황", .black, "VectorTrue")
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
                
                UserPriceView(orderItem: $orderItem)
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

// MARK: - UserPriceView
struct UserPriceView: View {
    @Binding var orderItem: OrderItem
    
    var priceText: (String, String) {
        switch orderItem.status {
        case .notAssign:
            return ("총 예상금액", intToString(orderItem.expectedPrice))
        case .assign, .complete:
            return ("총 확정금액", intToString(orderItem.confirmedPrice))
        }
    }
    
    var body: some View {
        HStack {
            CustomText(title: priceText.0, textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            Spacer()
                .frame(width: 45)
            CustomText(title: priceText.1, textColor: .black, textWeight: .semibold, textSize: 16)
            Spacer()
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
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
