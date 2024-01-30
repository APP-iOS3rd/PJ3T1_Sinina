//
//  DatePickerView.swift
//  SininaCake
//
//  Created by 박채운 on 1/24/24.
//

import SwiftUI

struct DatePickerView: View {
    @State private var showAlert = false

        var body: some View {
            Button("알림 보이기") {
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text("알림 내용을 여기에 작성하세요."),
                    dismissButton: .default(Text("확인")) {
                        // 확인 버튼을 눌렀을 때 수행할 동작 작성
                        print("확인 버튼이 눌렸습니다.")
                    }
                )
            }
        }
}

#Preview {
    DatePickerView()
}
