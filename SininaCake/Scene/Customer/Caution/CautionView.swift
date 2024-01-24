
import SwiftUI

struct CautionView: View {
    var body: some View {
        ZStack {
            TitleView()
        }
        VStack {
            ScrollView(showsIndicators: false){
                ScrollTitleView()
            }
        }
    }
}

private struct TitleView: View {
    var body: some View {
        CustomText(title: "주문전 확인사항", textColor: .black, textWeight: .semibold, textSize: 22)
            .padding()
    }
}

struct ScrollTitleView: View {
    
    @State private var cautionAll: Bool = false
    @State private var pickUp: Bool = false
    @State private var cakeCaution: Bool = false
    @State private var instaUpload: Bool = false
    @State private var Next: Bool = false
    
    
    var body: some View {
        VStack {
            CustomButton(action: {self.cautionAll.toggle()}, title: "전체동의", titleColor: cautionAll ? .white : .customGray , backgroundColor: cautionAll ? .customBlue : .textFieldColor, leading: 24, trailing: 24)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
            
            CautionButtonView(action: {self.pickUp.toggle()}, title: "예약/픽업 날짜", text: "ㆍ픽업을 원하는 날짜" + "최소 3일 전" + " 에 예약해주세요. \nㆍ예약은 입금순으로 마감됩니다. \nㆍ원하시는 디자인의 사진 또는 도안을 보내주세요. \nㆍ케이크 작업 중에는 답변이 느릴 수 있습니다. \nㆍ순차적으로 답변 드리니 조금만 기다려주세요~", width: 350, height: 200, check: pickUp)
                .onChange(of: [cautionAll]) { _ in
                    self.pickUp = self.cautionAll
                }
            
            CautionButtonView(action: {self.cakeCaution.toggle()}, title: "케이크 주의사항", text: "ㆍ글씨와 색깔은 사람의 손으로 하는 것이라 차이가 \n   있을 수 있습니다. \nㆍ화면과 기종에 따라 색감차이가 있습니다. \nㆍ색소는 온도와 경과 시간에 따라 번짐이 생깁니다. \n   최대한 픽업한 날 바로 사용해 주세요. \n   국내에서 허가된 식용색소만 사용하며 진한 컬러\n   (빨강, 검정 등)의 경우 색소침착이 발생하나\n   시간이 지나면 자연히 사라집니다. \n   민감하신 분들은 고려해 주세요.", width: 350, height: 240, check: cakeCaution)
                .onChange(of: [cautionAll]) { _ in
                    self.cakeCaution = self.cautionAll
                }
            
            CautionButtonView(action: {self.instaUpload.toggle()}, title: "인스타그램 업로드", text: "ㆍ완성된 케이크 사진은 인스타에 게시됩니다. \nㆍ원치 않으실 경우 미리 말씀해주세요.", width: 350, height: 130, check: instaUpload)
                .onChange(of: [cautionAll]) { _ in
                    self.instaUpload = self.cautionAll
                }
            
            CustomButton(action: {}, title: "확인", titleColor: Next ? .white : .customGray , backgroundColor: Next ? .customBlue : .textFieldColor, leading: 24, trailing: 24)
                .disabled(!Next)
                .onChange(of: [cautionAll, pickUp, cakeCaution, instaUpload]) { _ in
                    self.Next = isAllChecked(self.pickUp, self.cakeCaution, self.instaUpload)
                }
            
        }
    }
}

struct CautionButtonView: View {
    let action: () -> Void
    let title: String
    let text: String
    let width: CGFloat
    let height: CGFloat
    var check: Bool
    
    init(action: @escaping () -> Void, title: String, text: String, width: CGFloat, height: CGFloat, check: Bool) {
        self.action = action
        self.title = title
        self.text = text
        self.width = width
        self.height = height
        self.check = check
    }
    
    var body: some View {
        Button(action: {
            action()
        }){
            // 제목
            RoundedRectangle(cornerRadius: 12.0)
                .stroke(check ? Color(uiColor: .customBlue) : .white )
                .foregroundColor(.clear)
                .frame(width: width, height: height)
                .background(.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                .overlay( VStack(alignment: .leading){
                    HStack {
                        Image(check ? "VectorTrue" : "VectorFalse")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 14)
                            .padding(.leading, 4)
                        Text(title)
                            .font(.custom("Pretendard", size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Text ("(필수)")
                            .font(.custom("Pretendard", size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.customBlue))
                    }
                    // 실선
                    Divider()
                    
                    // 내용
                    CustomText(title: text, textColor: .textFieldTextColor, textWeight: .semibold, textSize: 16)
                        .kerning(0.3)
                        .multilineTextAlignment(.leading)
                })
            
        }
        
    }
}



#Preview {
    CautionView()
}

