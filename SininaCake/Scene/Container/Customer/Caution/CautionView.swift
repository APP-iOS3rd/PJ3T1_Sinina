
import SwiftUI

struct CautionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cautionAll: Bool = false
    @State private var pickUp: Bool = false
    @State private var cakeCaution: Bool = false
    @State private var instaUpload: Bool = false
    @State private var Next: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false){
                    ScrollTitleView(cautionAll: $cautionAll, pickUp: $pickUp, cakeCaution: $cakeCaution, instaUpload: $instaUpload, Next: $Next)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("주문 전 확인사항")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image("angle-left")
                            .foregroundStyle(Color.black)
                    })
                }
            }
            NavigationLink(destination: OrderView().navigationBarBackButtonHidden(), label: {
                ConfirmButton(cautionAll: $cautionAll,
                              pickUp: $pickUp,
                              cakeCaution: $cakeCaution,
                              instaUpload: $instaUpload,
                              isAgreed: $Next)})
        }
    }
}

private struct TitleView: View {
    var body: some View {
        Text("주문 전 확인사항")
            .font(.custom("Pretendard", size: 24))
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .padding(.vertical, UIScreen.UIWidth(21))
    }
}

struct ScrollTitleView: View {
    
    @Binding var cautionAll: Bool
    @Binding var pickUp: Bool
    @Binding var cakeCaution: Bool
    @Binding var instaUpload: Bool
    @Binding var Next: Bool
    
    
    var body: some View {
        LazyVStack(alignment: .center) {
            AllAgreeButton(cautionAll: $cautionAll, pickUp: $pickUp, cakeCaution: $cakeCaution, instaUpload: $instaUpload, isAgreed: $Next)
            // 예약/픽업 날짜
            Button(action: {
                self.pickUp.toggle()
            }){
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(pickUp ? Color(uiColor: .customBlue) : .white )
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.UIWidth(382), height: UIScreen.UIHeight(205))
                    .background(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    .overlay( VStack(alignment: .leading){
                        
                        HStack {
                            Image(pickUp ? "VectorTrue" : "VectorFalse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(17.9))
                            
                            
                            CustomText(title: "예약/픽업 날짜", textColor: .black, textWeight: .semibold, textSize: 16)
                            
                            CustomText(title: "(필수)", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                            
                        }
                        .padding(.leading, UIScreen.UIWidth(12))
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: UIScreen.UIWidth(334), height: UIScreen.UIHeight(1))
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .padding(.bottom, UIScreen.UIWidth(12))
                        
                        
                        HStack {
                            CustomText(title: "ㆍ픽업을 원하는 날짜", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "최소 3일 전", textColor: .customRed, textWeight: .semibold, textSize: 16)
                                .padding(.leading, UIScreen.UIWidth(-4))
                            CustomText(title: "에 예약해주세요.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                                .padding(.leading, UIScreen.UIWidth(-8))
                        }
                        
                        CustomText(title: "ㆍ예약은 입금순으로 마감됩니다.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        CustomText(title: "ㆍ원하시는 디자인의 사진 또는 도안을 보내주세요.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        CustomText(title: "ㆍ케이크 작업 중에는 답변이 느릴 수 있습니다.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        CustomText(title: "ㆍ순차적으로 답변 드리니 조금만 기다려주세요~", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                    })
            }
            .padding(.bottom, UIScreen.UIWidth(12))
            .onChange(of: [cautionAll]) { _ in
                self.pickUp = self.cautionAll
            }
            
            // 케이크 주의사항
            Button(action: {
                self.cakeCaution.toggle()
            }){
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(cakeCaution ? Color(uiColor: .customBlue) : .white )
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.UIWidth(382), height: UIScreen.UIHeight(292))
                    .background(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    .overlay( VStack(alignment: .leading){
                        
                        HStack {
                            Image(cakeCaution ? "VectorTrue" : "VectorFalse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(17.9))
                            
                            CustomText(title: "케이크 주의사항", textColor: .black, textWeight: .semibold, textSize: 16)
                            
                            CustomText(title: "(필수)", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                        }
                        .padding(.leading, UIScreen.UIWidth(12))
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: UIScreen.UIWidth(334), height: UIScreen.UIHeight(1))
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .padding(.bottom, 12)
                        
                        VStack(alignment: .leading){
                            CustomText(title: "ㆍ글씨와 색깔은 사람의 손으로 하는 것이라 차이가", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "   있을 수 있습니다.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "ㆍ색소는 온도와 경과 시간에 따라 번짐이 생깁니다.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            
                            CustomText(title: "   최대한 픽업한 날 바로 사용해 주세요. ", textColor: .customRed, textWeight: .semibold, textSize: 16)
                            
                            CustomText(title: "   국내에서 허가된 식용색소만 사용하며 진한 컬러", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "   (빨강, 검정 등)의 경우 색소침착이 발생하나", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "   시간이 지나면 자연히 사라집니다.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            CustomText(title: "   민감하신 분들은 고려해 주세요.", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                        }
                    })
            }
            .padding(.bottom, 12)
            .onChange(of: [cautionAll]) { _ in
                self.cakeCaution = self.cautionAll
            }
            
            // 인스타 그램 업로드
            Button(action: {
                self.instaUpload.toggle()
            }){
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(instaUpload ? Color(uiColor: .customBlue) : .white )
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.UIWidth(382), height: UIScreen.UIHeight(139))
                    .background(.white)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                    .overlay( VStack(alignment: .leading){
                        
                        HStack {
                            Image(instaUpload ? "VectorTrue" : "VectorFalse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(17.9))
                            
                            CustomText(title: "인스타그램 업로드", textColor: .black, textWeight: .semibold, textSize: 16)
                            
                            CustomText(title: "(필수)", textColor: .customBlue, textWeight: .semibold, textSize: 18)
                        }
                        .padding(.leading, UIScreen.UIWidth(12))
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: UIScreen.UIWidth(334), height: UIScreen.UIHeight(1))
                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                            .padding(.bottom, 12)
                        
                        VStack(alignment: .leading){
                            CustomText(title: "ㆍ완성된 케이크 사진은 인스타에 게시됩니다. ", textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            
                            CustomText(title: "ㆍ원치 않으실 경우 미리 말씀해주세요. ", textColor: .customRed, textWeight: .semibold, textSize: 16)
                        }
                    })
            }
            .padding(.bottom, 12)
            .onChange(of: [cautionAll]) { _ in
                self.instaUpload = self.cautionAll
            }
        }
    }
}

struct CustomTextModifier: ViewModifier {
    var fontColor: UIColor
    func body(content: Content) -> some View {
        content
            .font(.custom("Pretendard", size: 16))
            .fontWeight(.regular)
            .kerning(0.4)
            .multilineTextAlignment(.leading)
            .foregroundColor(Color(fontColor))
    }
}

struct AllAgreeButton: View {
    @Binding var cautionAll: Bool
    @Binding var pickUp: Bool
    @Binding var cakeCaution: Bool
    @Binding var instaUpload: Bool
    @Binding var isAgreed: Bool
    
    var body: some View {
        Button(action: {self.cautionAll.toggle()}, label: {
            Image(isAgreed ? "VectorWhite" : "VectorFalse")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(17.9))
                .padding(.leading, UIScreen.UIWidth(32))
            
            CustomText(title: "전체 동의", textColor: isAgreed ? .white : .customDarkGray , textWeight: .semibold, textSize: 18)
                .multilineTextAlignment(.leading)
                .padding(.leading, UIScreen.UIWidth(24))
            Spacer()
        })
        .frame(width: UIScreen.UIWidth(382), height: UIScreen.UIHeight(65))
        .background(Color(isAgreed ? .customBlue : .textFieldColor))
        .cornerRadius(45)
        .padding(.top, UIScreen.UIWidth(24))
        .padding(.bottom, UIScreen.UIWidth(12))
    }
}

struct ConfirmButton: View {
    @Binding var cautionAll: Bool
    @Binding var pickUp: Bool
    @Binding var cakeCaution: Bool
    @Binding var instaUpload: Bool
    @Binding var isAgreed: Bool
    
    var body: some View {
        CustomButton(action: {}, title: "확인", titleColor: isAgreed ? .white : .customDarkGray , backgroundColor: isAgreed ? .customBlue : .textFieldColor, leading: 24, trailing: 24)
            .disabled(isAgreed)
            .onChange(of: [cautionAll, pickUp, cakeCaution, instaUpload]) { _ in
                self.isAgreed = isAllChecked(self.pickUp, self.cakeCaution, self.instaUpload)
            }
    }
}

#Preview {
    CautionView()
}

