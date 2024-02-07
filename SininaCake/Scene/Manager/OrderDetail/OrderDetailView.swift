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
    @State private var totalPrice = ""
    @State private var isButtonActive = true
    @State private var isEditing: Bool = false
    @State private var scrollTarget: String?
    @StateObject var orderDetailVM = OrderDetailViewModel()
    
    var statusTitle: (String, UIColor, String) {
        switch orderItem.status {
        case .assign:
            return ("승인 주문건 현황", .customBlue, "assignCheckImage")
        case .notAssign:
            return ("미승인 주문건 현황", .customGray, "checkImage")
        case .complete:
            return ("완료 주문건 현황", .black, "assignCheckImage")
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
                
                ScrollViewReader { proxy in
                    PriceView(orderItem: $orderItem, toggle: $isButtonActive, totalPrice: $totalPrice, isEditing: $isEditing, scrollTarget: $scrollTarget, scrollProxy: proxy)
                }
                
                BottomButton(orderDetailVM: orderDetailVM, orderItem: $orderItem, toggle: $isButtonActive, totalPrice: $totalPrice)
                    .opacity(opacity)
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
            orderDetailVM.downloadImage(orderItem.imageURL)
        }
    }
}

// MARK: - DividerView
struct DividerView: View {
    var body: some View {
        Spacer()
            .frame(height: 32)
        
        Divider()
        
        Spacer()
            .frame(height: 32)
    }
}

// MARK: - OrderInfoView
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

// MARK: - PhotoView
struct PhotoView: View {
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
                if orderItem.imageURL.isEmpty {
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
struct EtcView: View {
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
                CustomText(title: "보냉팩 / 보냉백", textColor: .customGray, textWeight: .semibold, textSize: 16)
                CustomText(title: "추가 요청 사항", textColor: .customGray, textWeight: .semibold, textSize: 16)
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

// MARK: - PriceView
struct PriceView: View {
    @Binding var orderItem: OrderItem
    @Binding var toggle: Bool
    @Binding var totalPrice: String
    @Binding var isEditing: Bool
    @Binding var scrollTarget: String?
    var scrollProxy: ScrollViewProxy
    @FocusState var isFocused: Bool
    
    var priceText: (String, String) {
        switch orderItem.status {
        case .notAssign:
            return ("총 예상금액", intToString(orderItem.expectedPrice))
        case .assign, .complete:
            return ("총 확정금액", intToString(orderItem.confirmedPrice))
        }
    }
    
    var opacity: Double {
        switch orderItem.status {
        case .notAssign:
            return 1
        case .assign, .complete:
            return 0
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                CustomText(title: priceText.0, textColor: .customGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 45)
                CustomText(title: priceText.1, textColor: .black, textWeight: .semibold, textSize: 16)
                Spacer()
            }
            
            HStack {
                CustomText(title: "총 확정금액", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                Spacer()
                    .frame(width: 24)
                HStack {
                    TextField("", text: $totalPrice, onEditingChanged: { editing in
                        scrollTarget = "priceTextField"
                        withAnimation {
                            isEditing = editing
                        }
                    })
                        .padding()
                        .background(Color(.white))
                        .keyboardType(.numberPad)
                        .font(.custom("Pretendard", fixedSize: 20))
                        .fontWeight(.semibold)
                        .id("priceTextField")
                        .focused($isFocused)
                        .onTapGesture {
                            totalPrice = ""
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button(action: {
                                    toggle = false
                                    isFocused = false
                                    totalPrice = String(intToString(Int(totalPrice) ?? 0).dropLast())
                                }, label: {
                                    CustomText(title: "Done", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                                })
                            }
                        }
                        .overlay(
                            HStack {
                                Spacer()
                                CustomText(title: "원", textColor: .customGray, textWeight: .semibold, textSize: 20)
                            }
                            .padding(.trailing, 18)
                        )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 27.5)
                        .stroke(Color(.customGray))
                )
                Spacer()
            }
            .opacity(opacity)
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .onChange(of: scrollTarget) { target in
            if let target = target {
                withAnimation {
                    scrollProxy.scrollTo(target, anchor: .top)
                    
                    scrollTarget = nil
                }
            }
        }
    }
}

// MARK: - BottomButton
struct BottomButton: View {
    @ObservedObject var orderDetailVM: OrderDetailViewModel
    @Binding var orderItem: OrderItem
    @Binding var toggle: Bool
    @Binding var totalPrice: String
    
    var buttonStyle: (String, UIColor) {
        switch orderItem.status {
        case .notAssign:
            if toggle {
                return ("승인하기", .customGray)
            } else {
                return ("승인하기", .customBlue)
            }
        case .assign:
            return ("제작완료", .customBlue)
        case .complete:
            return ("", .black)
        }
    }
    
    var buttonToggle: Bool {
        switch orderItem.status {
        case .assign:
            return false
        default:
            return toggle
        }
    }

    var body: some View {
        CustomButton(action: {
            if orderItem.status == .notAssign {
                orderDetailVM.updateStatus(orderItem: orderItem)
                orderDetailVM.updatePrice(orderItem: orderItem, stringToInt(totalPrice))
            } else {
                orderDetailVM.updateStatus(orderItem: orderItem)
            }
        }, title: buttonStyle.0, titleColor: .white, backgroundColor: buttonStyle.1, leading: 24, trailing: 24)
            .padding(.top, 29)
            .disabled(buttonToggle)
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
