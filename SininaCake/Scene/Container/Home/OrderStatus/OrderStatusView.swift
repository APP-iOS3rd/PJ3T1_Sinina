//
//  OrderStatusView.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import SwiftUI

struct OrderStatusView: View {
    
    
    @StateObject var orderListVM = OrderListViewModel()
    
    @State var toto = false
    
    var body: some View {
        NavigationStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 342, height: 30)
                .background(
                    HStack() {
                        
                        Text("주문현황")
                            .font(
                                Font.custom("Pretendard", fixedSize: 24)
                                    .weight(.semibold)
                            )
                        Spacer()
                    }
                )
            
            if false {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 342, height: 383)
                    .background(
                        ZStack {
                            
                            
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                            
                            VStack() {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 342, height: 170)
                                    .background(
                                        Image("jingjing")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 306, height: 170)
                                            .clipped()
                                        
                                    )
                                statusView
                            }
                            
                            
                        }
                        
                        
                    )
                
            }
            else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 342, height: 403)
                    .background(
                        
                        ZStack {
                            
                            
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                            
                            VStack() {
                                
                                Image("cake")
                                    .resizable()
                                    .frame(width: 34, height: 25.54)
                                Text("예약된 주문이 아직 없어요!")
                                    .font(
                                        Font.custom("Pretendard", fixedSize: 18)
                                            .weight(.semibold)
                                    )
                                    .kerning(0.45)
                                    .foregroundColor(Color(UIColor.customDarkGray))
                                ZStack() {
                                    if toto == true {
                                        NavigationLink(destination: OrderView()){
                                            
                                            Text("주문하러 가기")
                                                .frame(width: 161, height: 43)
                                                .background(Color(UIColor.customBlue))
                                            
                                                .cornerRadius(45)
                                                .font(
                                                    Font.custom("Pretendard", fixedSize: 16)
                                                        .weight(.semibold)
                                                )
                                                .kerning(0.4)
                                                .foregroundColor(.white)
                                        }
                                    } else { NavigationLink(destination: CalendarView()){
                                        
                                        Text("주문하러 가기")
                                            .frame(width: 161, height: 43)
                                            .background(Color(UIColor.customBlue))
                                        
                                            .cornerRadius(45)
                                            .font(
                                                Font.custom("Pretendard", fixedSize: 16)
                                                    .weight(.semibold)
                                            )
                                            .kerning(0.4)
                                            .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    )
            }
        }
    }
    
    
    
    
    
    private var statusView: some View {
        let orderItem: OrderItem = OrderItem(id:"", email:"" ,date: Date(), orderTime: Date(), cakeSize: "", sheet: "초코시트", cream: "블루베리",icePack: .none, name: "이찰떡", phoneNumber: "010-1234-5678", text: "", imageURL: [""], comment: "",expectedPrice:25000, confirmedPrice:25000, status: .assign)
        
        
        
        return Rectangle()
            .foregroundColor(.clear)
            .frame(width: 312, height: 203)
            .background(
                VStack(alignment:.leading, spacing: 15) {
                    Spacer()
                    
                    HStack {
                        CustomText(title: dateToString(orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Image(systemName: "clock")
                            .font(.custom("PreTendard", fixedSize: 18))
                            .foregroundStyle(Color(.customBlue))
                        
                        CustomText(title: dateToTime(orderItem.date), textColor: .customBlue, textWeight: .semibold, textSize: 18)
                    }
                    
                    HStack {
                        
                        CustomText(title: orderItem.sheet, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        CustomText(title: "/", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        CustomText(title: orderItem.cream, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        
                    }
                    
                    Divider()
                        .frame(width: 300)
                    
                    HStack() {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            CustomText(title: "예약자", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                            CustomText(title: "전화번호", textColor: .customDarkGray, textWeight: .semibold, textSize: 16)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            CustomText(title: orderItem.name, textColor: .black, textWeight: .regular, textSize: 16)
                            CustomText(title: orderItem.phoneNumber, textColor: .black, textWeight: .regular, textSize: 16)
                        }
                        
                        Spacer()
                        
                    }
                    Spacer()
                }
            )
    }
    
    
    
    
    
    
    
    
    var dateString: String? {
        let date =  Date()                     // 넣을 데이터(현재 시간)
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "YYYY/MM/dd(EEEEE)"  // 변환할 형식
        myFormatter.locale = Locale(identifier: "ko_KR")
        let dateString = myFormatter.string(from: date)
        
        return dateString
    }
    
    
    
    var timeString: String? {
        let date =  Date()                     // 넣을 데이터(현재 시간)
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "HH:mm"  // 변환할 형식
        myFormatter.locale = Locale(identifier: "ko_KR")
        let timeString = myFormatter.string(from: date)
        
        return timeString
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
}







#Preview {
    OrderStatusView()
}

