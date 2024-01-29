//
//  OrderListView.swift
//  SininaCake
//
//  Created by  zoa0945 on 11/12/23.
//

import SwiftUI

struct OrderListView: View {
    // Dummy Data
    private var orderData: [OrderItem] = [
        OrderItem(date: "2023/09/23(금)", time: "12:30", cakeSize: "도시락", sheet: "초코시트", cream: "크림치즈프로스팅", customer: "김고구마", phoneNumber: "010-0000-0000", text: "생일축하해", imageURL: [""], comment: "보냉백 추가할게요!", price: 25000),
        OrderItem(date: "2023/09/23(금)", time: "12:30", cakeSize: "도시락", sheet: "초코시트", cream: "크림치즈프로스팅", customer: "김고구마", phoneNumber: "010-0000-0000", text: "생일축하해", imageURL: [""], comment: "보냉백 추가할게요!", price: 25000),
        OrderItem(date: "2023/09/23(금)", time: "12:30", cakeSize: "도시락", sheet: "초코시트", cream: "크림치즈프로스팅", customer: "김고구마", phoneNumber: "010-0000-0000", text: "생일축하해", imageURL: [""], comment: "보냉백 추가할게요!", price: 25000)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(
                    header: CustomText(title: "미승인 주문건 현황", textColor: .red, textWeight: .semibold, textSize: 18)
                ) {
                    ForEach(0..<orderData.count, id: \.self) { i in
                        NavigationLink(value: i) {
                            ListCellView(orderItem: orderData[i])
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                
                Section(
                    header: CustomText(title: "승인 주문건 현황", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                ) {
                    ForEach(0..<orderData.count, id: \.self) { i in
                        NavigationLink(value: i) {
                            ListCellView(orderItem: orderData[i])
                                .listRowSeparator(.hidden)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationDestination(for: Int.self) { i in
                OrderDetailView(orderItem: orderData[i])
            }
            .navigationDestination(for: Int.self) { i in
                OrderDetailView(orderItem: orderData[i])
            }
        }
    }
}

private struct ListCellView: View {
    
    let orderItem: OrderItem
    
    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                CustomText(title: orderItem.date, textColor: .black, textWeight: .semibold, textSize: 18)
                Spacer()
                Image(systemName: "clock")
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(.customBlue))
                CustomText(title: orderItem.time, textColor: .customBlue, textWeight: .semibold, textSize: 18)
            }
            
            HStack {
                CustomText(title: orderItem.cakeSize, textColor: .black, textWeight: .semibold, textSize: 18)
                CustomText(title: orderItem.sheet, textColor: .gray, textWeight: .regular, textSize: 16)
                CustomText(title: "/", textColor: .gray, textWeight: .regular, textSize: 16)
                CustomText(title: orderItem.cream, textColor: .gray, textWeight: .regular, textSize: 16)
                Spacer()
            }
            
            Divider()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(title: "예약자", textColor: .gray, textWeight: .semibold, textSize: 16)
                    CustomText(title: "전화번호", textColor: .gray, textWeight: .semibold, textSize: 16)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    CustomText(title: orderItem.customer, textColor: .black, textWeight: .regular, textSize: 16)
                    CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .regular, textSize: 16)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    CustomText(title: "총 예상금액", textColor: .gray, textWeight: .semibold, textSize: 14)
                    CustomText(title: "\(orderItem.price)원", textColor: .black, textWeight: .semibold, textSize: 18)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.gray))
        )
    }
}

#Preview {
    OrderListView()
}
