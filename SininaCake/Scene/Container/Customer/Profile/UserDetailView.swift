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
    
    var opacity: Double {
        switch orderItem.status {
        case .complete:
            return 0
        default:
            return 1
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
                
                UserOrderInfoView(orderItem: $orderItem)
                
                UserDividerView()
                
                UserCakeInfoView(orderItem: $orderItem)
                
                Spacer()
                    .frame(height: 18)
                
                UserPhotoView(orderItem: $orderItem, orderDetailVM: orderDetailVM)
                
                Spacer()
                    .frame(height: 32)
                
                UserEtcView(orderItem: $orderItem)
                
                UserDividerView()
                
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
            orderDetailVM.downloadImage(orderItem.id, orderItem.imageURL)
        }
    }
}

// MARK: - DividerView
struct UserDividerView: View {
    var body: some View {
        Spacer()
            .frame(height: 32)
        
        Divider()
        
        Spacer()
            .frame(height: 32)
    }
}

// MARK: - OrderInfoView
struct UserOrderInfoView: View {
    @Binding var orderItem: OrderItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: "픽업날짜", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "픽업시간", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "이름", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "휴대전화", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            
            Spacer()
                .frame(width: 63)
            
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: dateToString(orderItem.date), textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: dateToTime(orderItem.date), textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.name, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .semibold, textSize: 16)
            }
            
            Spacer()
        }
        .padding(.leading, 24)
    }
}

// MARK: - CakeInfoView
struct UserCakeInfoView: View {
    @Binding var orderItem: OrderItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: "사이즈", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "시트(빵)", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "속크링", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "문구/글씨 색상", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
            }
            
            Spacer()
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: orderItem.cakeSize, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.sheet, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.cream, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.text, textColor: .black, textWeight: .semibold, textSize: 16)
            }
            
            Spacer()
        }
        .padding(.leading, 24)
    }
}

// MARK: - PhotoView
struct UserPhotoView: View {
    @Binding var orderItem: OrderItem
    @ObservedObject var orderDetailVM: OrderDetailViewModel
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let imageWidth = (UIScreen.main.bounds.width - 60) / 2
    
    var body: some View {
        VStack {
            HStack {
                CustomText(title: "사진", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            
            Spacer()
                .frame(height: 24)

            LazyVGrid(columns: columns) {
                if orderItem.imageURL.count == 1 && orderItem.imageURL[0] == "" {
                    ForEach(0...1, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.customGray))
                            .frame(width: imageWidth, height: imageWidth)
                            .foregroundStyle(.clear)
                            .overlay(
                                Image("emptyPhoto")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFit()
                            )
                    }
                } else {
                    ForEach(orderDetailVM.images, id: \.self) { image in
                        if let image = image {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.customGray))
                                .frame(width: imageWidth, height: imageWidth)
                                .foregroundStyle(.clear)
                                .overlay(
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: imageWidth - 20, height: imageWidth - 20)
                                        .scaledToFit()
                                )
                        }
                    }
                    
                    if orderItem.imageURL.count % 2 == 1 {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.customGray))
                            .frame(width: imageWidth, height: imageWidth)
                            .foregroundStyle(.clear)
                            .overlay(
                                Image("emptyPhoto")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFit()
                            )
                    }
                }
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

// MARK: - EtcView
struct UserEtcView: View {
    @Binding var orderItem: OrderItem
    var icePackTitle: String {
        switch orderItem.icePack {
        case .none:
            return "없음"
        case .icePack:
            return "보냉팩(+1000원) 추가"
        case .iceBag:
            return "보냉백(+5000원) 추가"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: "보냉팩 / 보냉백", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "추가 요청 사항", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 18) {
                CustomText(title: icePackTitle, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.comment, textColor: .black, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            
            Spacer()
        }
        .padding(.leading, 24)
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
