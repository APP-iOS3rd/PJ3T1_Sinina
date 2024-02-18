//
//  OrderStatusView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI

struct OrderStatusView: View {
    @StateObject var orderStatusVM = OrderStatusViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    CustomText(title: "주문현황", textColor: .black, textWeight: .semibold, textSize: 24)
                    Spacer()
                }
                
                StatusView(orderStatusVM: orderStatusVM)
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.top, 24)
            .navigationDestination(for: OrderItem.self) { item in
                UserDetailView(orderItem: item)
            }
        }
    }
}

struct StatusView: View {
    @ObservedObject var orderStatusVM: OrderStatusViewModel
    
    var body: some View {
        if orderStatusVM.myOrderData.isEmpty {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color(.white))
                .frame(height: UIScreen.main.bounds.width - 96)
                .overlay(
                    VStack() {
                        Image("cake")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color(.customGray))
                            .frame(width: 20, height: 20)
                        CustomText(title: "예약된 주문이 아직 없어요!", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                        
                        Spacer()
                            .frame(height: 18)
                        
                        NavigationLink(destination: CautionView()) {
                            HStack {
                                Spacer()
                                CustomText(title: "주문하러 가기", textColor: .white, textWeight: .semibold, textSize: 16)
                                    .frame(minHeight: 45)
                                Spacer()
                            }
                            .background(Color(.customBlue))
                            .cornerRadius(22.5)
                            .padding(.horizontal, 110)
                        }
                    }
                )
        } else {
            ForEach(0..<orderStatusVM.myOrderData.count, id: \.self) { i in
                NavigationLink(value: orderStatusVM.myOrderData[i]) {
                    StatusInfo(orderStatusVM: orderStatusVM, orderItem: orderStatusVM.myOrderData[i])
                }
            }
        }
    }
}

struct StatusInfo: View {
    @ObservedObject var orderStatusVM: OrderStatusViewModel
    let orderItem: OrderItem
    @State var thumbnailImage: UIImage? = nil
    let imageWidth = UIScreen.main.bounds.width - 48
    
    var body: some View {
        VStack(spacing: 0) {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageWidth / 2)
                    .cornerRadius(12)
                    .clipped()
            } else {
                Image("emptyPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageWidth, height: imageWidth / 2)
                    .cornerRadius(12)
                    .clipped()
            }
            DetailInfoView(orderItem: orderItem)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.customGray))
        )
        .overlay(
            VStack {
                HStack {
                    DdayView(orderItem: orderItem)
                    Spacer()
                }
                Spacer()
            }
        )
        .onAppear {
            if orderItem.imageURL[0] != "" {
                orderStatusVM.downloadImage(orderItem.id, orderItem.imageURL[0]) { image in
                    DispatchQueue.main.async {
                        self.thumbnailImage = image
                    }
                }
            }
        }
    }
}

struct DdayView: View {
    let orderItem: OrderItem
    
    var titleAndColor: (String, UIColor, UIColor) {
        switch orderItem.status {
        case .assign, .complete:
            return (dateToDday(orderItem.date), .white, .customBlue)
        case .notAssign:
            return ("예약대기", .customDarkGray, .customGray)
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

struct DetailInfoView: View {
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
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            HStack {
                CustomText(title: orderItem.cakeSize, textColor: .black, textWeight: .semibold, textSize: 18)
                CustomText(title: "\(orderItem.sheet) / \(orderItem.cream)", textColor: .customGray, textWeight: .regular, textSize: 16)
                Spacer()
            }
            .padding(.horizontal, 24)
            
            Divider()
            
            HStack(spacing: 32) {
                CustomText(title: "예약자", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.name, textColor: .black, textWeight: .regular, textSize: 16)
                Spacer()
            }
            .padding(.horizontal, 24)
            
            HStack(spacing: 18) {
                CustomText(title: "전화번호", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .regular, textSize: 16)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color(.white))
        .clipShape(
            .rect(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
        )
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

private func dateToDday(_ completeDate: Date) -> String {
    var dayCount = 0
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: completeDate)
    
    guard let startDate = formatter.date(from: dateString) else { return "" }
    dayCount = days(from: startDate)
    if dayCount > 0 {
        return "D - \(dayCount)"
    } else if dayCount == 0 {
        return "D - Day"
    } else {
        return "D + \(dayCount * -1)"
    }
}

private func days(from date: Date) -> Int {
    if let dDay = Calendar.current.dateComponents([.day], from: date, to: Date()).day {
        return dDay
    }
    
    return 0
}
