//
//  UserConfirmOrderDetailView.swift
//  SininaCake
//
//  Created by 이종원 on 2/18/24.
//

import SwiftUI

struct UserConfirmOrderDetailView: View {
    
    @ObservedObject var orderVM: OrderViewModel
//    @Binding var stackCount
    
    var body: some View {
        VStack {
            UserDetailView(orderItem: orderVM.orderItem)
            CustomButton(action: {
                orderVM.addOrderItem()
                
            }, title: "주문서 보내기", titleColor: .white, backgroundColor: .customBlue, leading: 12, trailing: 12)
        }
    }
}

// TODO:OrderViewModel 전달해서 여기서 주문 DB에 저장 


//#Preview {
//    UserConfirmOrderDetailView(orderVM: )
//}
