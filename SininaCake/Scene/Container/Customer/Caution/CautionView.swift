
import SwiftUI

struct CautionView: View {
    @State private var cautionAll: Bool
    @State private var pickUp: Bool
    @State private var cakeCaution: Bool
    @State private var instaUpload: Bool
    @State private var Next: Bool
    
    init(cautionAll: Bool, pickUp: Bool, cakeCaution: Bool, instaUpload: Bool, Next: Bool) {
        self.cautionAll = cautionAll
        self.pickUp = pickUp
        self.cakeCaution = cakeCaution
        self.instaUpload = instaUpload
        self.Next = Next
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false){
                    ScrollTitleView(cautionAll: $cautionAll, pickUp: $pickUp, cakeCaution: $cakeCaution, instaUpload: $instaUpload, Next: $Next)
                }
                .navigationBarTitle("주문 전 확인사항")
                .navigationBarTitleDisplayMode(.inline)
 
            }
        }
        cautionbottomView(cautionAll: $cautionAll, pickUp: $pickUp, cakeCaution: $cakeCaution, instaUpload: $instaUpload, Next: $Next)
    }
}

private struct TitleView: View {
    var body: some View {
        Text("주문 전 확인사항")
            .font(.custom("Pretendard", size: 24))
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .padding(.vertical, 21)
    }
}

struct ScrollTitleView: View {
    
    @Binding var cautionAll: Bool
    @Binding var pickUp: Bool
    @Binding var cakeCaution: Bool
    @Binding var instaUpload: Bool
    @Binding var Next: Bool
    
    
    var body: some View {
        LazyVStack(alignment: .center){
            
            // 예약/픽업 날짜
                Button(action: {self.cautionAll.toggle()}, label: {
                    Image(cautionAll ? "VectorWhite" : "VectorFalse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 14)
                        .padding(.leading, 26)
                    
                    CustomText(title: "전체동의", textColor: cautionAll ? .white : .customGray , textWeight: .semibold, textSize: 18)
                        .multilineTextAlignment(.leading)
                    Spacer()
                })
                .frame(width: 382, height: 70)
                .background(Color(cautionAll ? .customBlue : .textFieldColor))
                .cornerRadius(27.5)
                .padding(.top, 24)
                .padding(.bottom, 12)
                
                Button(action: {
                    self.pickUp.toggle()
                }){
                    RoundedRectangle(cornerRadius: 12.0)
                        .stroke(pickUp ? Color(uiColor: .customBlue) : .white )
                        .foregroundColor(.clear)
                        .frame(width: 382, height: 205)
                        .background(.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                        .overlay( VStack(alignment: .leading){
                            
                            HStack {
                                Image(pickUp ? "VectorTrue" : "VectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 14)
                                
                                
                                Text("예약/픽업 날짜")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text ("(필수)")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.customBlue))
                            }
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 334, height: 1)
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .padding(.bottom, 12)
                            
                            HStack{
                                Text("ㆍ픽업을 원하는 날짜")
                                    .modifier(CustomTextModifier(fontColor: UIColor.textFieldTextColor))
                                Text("최소 3일 전")
                                    .modifier(CustomTextModifier(fontColor: .customRed))
                                Text("에 예약해주세요.")
                                    .modifier(CustomTextModifier(fontColor: UIColor.textFieldTextColor))
                            }
                            Text("ㆍ예약은 입금순으로 마감됩니다. \nㆍ원하시는 디자인의 사진 또는 도안을 보내주세요. \nㆍ케이크 작업 중에는 답변이 느릴 수 있습니다. \nㆍ순차적으로 답변 드리니 조금만 기다려주세요~")
                                .modifier(CustomTextModifier(fontColor: UIColor.textFieldTextColor))
                        })
                }
                .padding(.bottom, 12)
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
                        .frame(width: 382, height: 292)
                        .background(.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                        .overlay( VStack(alignment: .leading){
                            
                            HStack {
                                Image(cakeCaution ? "VectorTrue" : "VectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 14)
                                
                                
                                Text("케이크 주의사항")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text ("(필수)")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.customBlue))
                            }
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 334, height: 1)
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .padding(.bottom, 12)
                            
                            VStack(alignment: .leading){
                                Text("ㆍ글씨와 색깔은 사람의 손으로 하는 것이라 차이가 \n   있을 수 있습니다. \nㆍ화면과 기종에 따라 색감차이가 있습니다. \nㆍ색소는 온도와 경과 시간에 따라 번짐이 생깁니다.")
                                    .modifier(CustomTextModifier(fontColor: .textFieldTextColor))
                                Text("   최대한 픽업한 날 바로 사용해 주세요. ")
                                    .modifier(CustomTextModifier(fontColor: .customRed))
                                Text("   국내에서 허가된 식용색소만 사용하며 진한 컬러\n   (빨강, 검정 등)의 경우 색소침착이 발생하나\n   시간이 지나면 자연히 사라집니다. \n   민감하신 분들은 고려해 주세요.")
                                    .modifier(CustomTextModifier(fontColor: .textFieldTextColor))
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
                        .frame(width: 382, height: 139)
                        .background(.white)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 8)
                        .overlay( VStack(alignment: .leading){
                            
                            HStack {
                                Image(instaUpload ? "VectorTrue" : "VectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 14)
                                
                                Text("인스타그램 업로드")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text ("(필수)")
                                    .font(.custom("Pretendard", size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.customBlue))
                            }
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 334, height: 1)
                                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                .padding(.bottom, 12)
                            
                            VStack(alignment: .leading){
                                Text("ㆍ완성된 케이크 사진은 인스타에 게시됩니다. ")
                                    .modifier(CustomTextModifier(fontColor: .textFieldTextColor))
                                Text("ㆍ원치 않으실 경우 미리 말씀해주세요. ")
                                    .modifier(CustomTextModifier(fontColor: .customRed))
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

struct cautionbottomView: View {
    @Binding  var cautionAll: Bool
    @Binding  var pickUp: Bool
    @Binding  var cakeCaution: Bool
    @Binding  var instaUpload: Bool
    @Binding  var Next: Bool
    
    var body: some View {
        CustomButton(action: {}, title: "확인", titleColor: Next ? .white : .customGray , backgroundColor: Next ? .customBlue : .textFieldColor, leading: 24, trailing: 24)
            .disabled(!Next)
            .onChange(of: [cautionAll, pickUp, cakeCaution, instaUpload]) { _ in
                self.Next = isAllChecked(self.pickUp, self.cakeCaution, self.instaUpload)
            }
    }
}

#Preview {
    CautionView(cautionAll: false, pickUp: false, cakeCaution: false, instaUpload: false, Next: false)
}

