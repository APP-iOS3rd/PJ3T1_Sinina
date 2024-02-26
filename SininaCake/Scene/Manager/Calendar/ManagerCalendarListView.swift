//
//  CalendarListView.swift
//  SininaCake
//
//  Created by 박채운 on 2/19/24.
//

import SwiftUI

struct ManagerCalendarListView: View {
    @StateObject var calendarListVM = ManagerCalendarListViewModel()
    
    var body: some View {
        ScrollView {
            CalListView(orderData: calendarListVM.allOrderData, title: "모든 주문 현황", titleColor: .black)
        }
        .onAppear {
            calendarListVM.fetchData()
        }
    }
}

struct CalListView: View {
    let orderData: [OrderItem]
    let title: String
    let titleColor: UIColor
    
    init(orderData: [OrderItem], title: String, titleColor: UIColor) {
        self.orderData = orderData
        self.title = title
        self.titleColor = titleColor
    }
    
    var body: some View {
        let sortedOrderData = orderData.sorted { $0.date < $1.date }
        
        VStack(spacing: 14) {
            HStack {
                CustomText(title: title, textColor: titleColor, textWeight: .semibold, textSize: 18)
                Spacer()
            }
            
            if sortedOrderData.isEmpty {
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
                ForEach(0..<sortedOrderData.count, id: \.self) { i in
                    NavigationLink(destination: OrderDetailView(orderItem: sortedOrderData[i])) {
                        CalendarCellView(orderItem: sortedOrderData[i])
                    }
                }
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 40)
    }
}

private struct CalendarCellView: View {
    
    let orderItem: OrderItem
    
    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }
    
    var body: some View {
        var statusColor: UIColor {
            switch orderItem.status {
            case .notAssign:
                return .customGray
            case .assign, .progress:
                return .customBlue
            case .complete, .pickup:
                return .black
            }
        }
        
        var price: (String, Int) {
            switch orderItem.status {
            case .notAssign:
                return ("총 예상금액", orderItem.expectedPrice)
            default:
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
                CustomText(title: orderItem.sheet, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                CustomText(title: "/", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                CustomText(title: orderItem.cream, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                Spacer()
            }
            
            Divider()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(title: "예약자", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                    CustomText(title: "전화번호", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
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
        if count % 3 == 0 && count != priceString.count {
            result += ","
        }
    }
    
    return result.reversed() + "원"
}

#Preview {
    ManagerCalendarListView()
}
