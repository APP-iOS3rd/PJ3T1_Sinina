//
//  OrderDetailView.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var orderItem: OrderItem
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(.customGray))
                    CustomText(title: "미승인 주문건 현황", textColor: .black, textWeight: .semibold, textSize: 18)
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
                
                PhotoView(orderItem: $orderItem)
                
                DividerView()
                
                PriceView(orderItem: $orderItem)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("주문현황")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color.black)
                })
            }
        }
        AssignButton()
    }
}

struct DividerView: View {
    var body: some View {
        Spacer()
            .frame(height: 32)
        
        Divider()
        
        Spacer()
            .frame(height: 32)
    }
}

struct OrderInfoView: View {
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
                CustomText(title: orderItem.date, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.time, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.customer, textColor: .black, textWeight: .semibold, textSize: 16)
                CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .semibold, textSize: 16)
            }
            
            Spacer()
        }
        .padding(.leading, 24)
    }
}

struct CakeInfoView: View {
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

struct PhotoView: View {
    @Binding var orderItem: OrderItem
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
            
            LazyVGrid(columns: columns, spacing: 34) {
                ForEach((0..<orderItem.imageURL.count), id: \.self) { i in
                    Image(systemName: orderItem.imageURL[i])
                        .resizable()
                        .frame(width: imageWidth - 20, height: imageWidth - 20)
                        .scaledToFit()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.customGray))
                                .frame(width: imageWidth, height: imageWidth)
                        )
                }
            }
            
            Spacer()
                .frame(height: 28)
            
            HStack {
                CustomText(title: "추가 요청 사항", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 26)
                CustomText(title: orderItem.comment, textColor: .black, textWeight: .semibold, textSize: 16)
                Spacer()
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

struct PriceView: View {
    @Binding var orderItem: OrderItem
    @State var totalPrice = ""
    
    var body: some View {
        VStack {
            HStack {
                CustomText(title: "총 예상금액", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 45)
                CustomText(title: intToString(orderItem.price), textColor: .black, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            
            HStack {
                CustomText(title: "총 확정금액", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 24)
                HStack {
                    TextField("", text: $totalPrice)
                        .padding()
                        .background(Color(.white))
                        .keyboardType(.decimalPad)
                    Button(action: {}, label: {
                        CustomText(title: "등록", textColor: .white, textWeight: .semibold, textSize: 16)
                    })
                    .frame(width: 94, height: 55)
                    .background(Color(.customBlue))
                    .cornerRadius(12)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.customGray))
                )
                Spacer()
            }
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
    }
}

struct AssignButton: View {
    var body: some View {
        CustomButton(action: {}, title: "승인하기", titleColor: .white, backgroundColor: .customBlue, leading: 24, trailing: 24)
            .padding(.top, 29)
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

#Preview {
    OrderDetailView(orderItem: OrderItem(date: "2023/09/23(금)", time: "12:30", cakeSize: "도시락", sheet: "초코시트", cream: "크림치즈프로스팅", customer: "김고구마", phoneNumber: "010-0000-0000", text: "생일축하해", imageURL: ["sun.max.fill", "sun.max.fill", "sun.max.fill"], comment: "보냉백 추가할게요!", price: 1025000, status: .assign))
}
