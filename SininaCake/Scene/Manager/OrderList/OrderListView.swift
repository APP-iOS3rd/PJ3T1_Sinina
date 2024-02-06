//
//  OrderListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct OrderListView: View {
    @StateObject var orderListVM = OrderListViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ListView(orderData: orderListVM.notAssignOrderData, title: "미승인 주문 현황", titleColor: .customRed)
                
                Spacer()
                    .frame(height: 28)
                
                ListView(orderData: orderListVM.assignOrderData, title: "승인 주문 현황", titleColor: .customBlue)
                
                Spacer()
                    .frame(height: 28)
                
                ListView(orderData: orderListVM.completeOrderData, title: "완료된 주문 현황", titleColor: .black)
            }
            .navigationDestination(for: OrderItem.self) { item in
                OrderDetailView(orderItem: item)
            }
            .onAppear {
                orderListVM.fetchData()
            }
        }
    }
}

struct ListView: View {
    let orderData: [OrderItem]
    let title: String
    let titleColor: UIColor
    
    init(orderData: [OrderItem], title: String, titleColor: UIColor) {
        self.orderData = orderData
        self.title = title
        self.titleColor = titleColor
    }
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                CustomText(title: title, textColor: titleColor, textWeight: .semibold, textSize: 18)
                Spacer()
            }
            
            ForEach(0..<orderData.count, id: \.self) { i in
                NavigationLink(value: orderData[i]) {
                    CellView(orderItem: orderData[i])
                }
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 40)
    }
}

private struct CellView: View {
    
    let orderItem: OrderItem
    
    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }
    
    var body: some View {
        var statusColor: UIColor {
            switch orderItem.status {
            case .assign:
                return .customBlue
            case .notAssign:
                return .customLightgray
            case .complete:
                return .black
            }
        }
        
        var price: (String, Int) {
            switch orderItem.status {
            case .notAssign:
                return ("총 예상금액", orderItem.expectedPrice)
            case .assign, .complete:
                return ("총 확정금액", orderItem.confirmedPrice)
            }
        }
        
        VStack(spacing: 10) {
            HStack {
                CustomText(title: dateToString(orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
                Spacer()
                Image(systemName: "clock")
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(statusColor))
                CustomText(title: dateToTime(orderItem.date), textColor: statusColor, textWeight: .semibold, textSize: 18)
            }
            
            HStack {
                CustomText(title: orderItem.cakeSize, textColor: .black, textWeight: .semibold, textSize: 18)
                CustomText(title: orderItem.sheet, textColor: .customGray, textWeight: .regular, textSize: 16)
                CustomText(title: "/", textColor: .customGray, textWeight: .regular, textSize: 16)
                CustomText(title: orderItem.cream, textColor: .customGray, textWeight: .regular, textSize: 16)
                Spacer()
            }
            
            Divider()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(title: "예약자", textColor: .customGray, textWeight: .semibold, textSize: 16)
                    CustomText(title: "전화번호", textColor: .customGray, textWeight: .semibold, textSize: 16)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(title: orderItem.name, textColor: .black, textWeight: .regular, textSize: 16)
                    CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .regular, textSize: 16)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    CustomText(title: price.0, textColor: .gray, textWeight: .semibold, textSize: 14)
                    CustomText(title: intToString(price.1), textColor: .black, textWeight: .semibold, textSize: 18)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(statusColor))
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
        if count % 3 == 0 {
            result += ","
        }
    }
    
    return result.reversed() + "원"
}

private func dateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko-KR")
    dateFormatter.dateFormat = "yyyy/MM/dd(E)"
    
    let dateString = dateFormatter.string(from: date)
    return dateString
}

private func dateToTime(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let timeString = dateFormatter.string(from: date)
    return timeString
}

#Preview {
    OrderListView()
}
