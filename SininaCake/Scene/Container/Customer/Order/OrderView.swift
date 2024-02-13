
import SwiftUI
import FirebaseStorage
import PhotosUI

struct OrderView: View {
    @StateObject var chart = OrderVM(orderItem: OrderItem(email: "", date: Date(), orderTime: Date(), cakeSize: "", sheet: "", cream: "", icePack: .none, name: "", phoneNumber: "", text: "", imageURL: [""], comment: "", expectedPrice: 0, confirmedPrice: 0, status: .notAssign))
    @StateObject private var photoVM = PhotoPickerVm()
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(showsIndicators: false){
                    ScrollOrderTitleView(chart: chart, photoVM: photoVM)
                }
            }
            .navigationTitle("주문하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        BottomView(chart: chart, photoVM: photoVM)
    }
}

struct ScrollOrderTitleView: View {
    @ObservedObject var chart: OrderVM
    @ObservedObject var photoVM: PhotoPickerVm
    
    @State private var check: Bool = true
    @State private var size: [String:Bool]  = ["도시락": false, "미니" : false, "1호" : false, "2호" : false, "3호" : false]
    @State private var sheet: [String:Bool]  = ["바닐라 시트": false, "초코 시트": false]
    @State private var cream: [String:Bool]  = ["크림치즈 프로스팅": false, "오레오" : false, "블루베리" : false, "초코" : false]
    @State private var icepack: [String:Bool] = ["보냉팩": false, "보냉백": false]
    
    let columns = [
        GridItem(.flexible(), spacing: nil),
        GridItem(.flexible(), spacing: nil)
    ]
    
    var body: some View {
        LazyVStack(alignment: .leading){
            
            /// 이름
            CustomText(title: "이름", textColor: .black, textWeight: .semibold , textSize: 18)
                .kerning(0.45)
                .padding(.leading, 24)
            
            TextField("ex) 시니나...", text: $chart.orderItem.name)
                .textFieldStyle(.plain)
                .padding(.leading, 24)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/930)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.bottom, 36)
            
            /// 휴대폰 번호
            CustomText(title: "휴대폰 번호", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            TextField("010 -", text: $chart.orderItem.phoneNumber)
                .textFieldStyle(.plain)
                .keyboardType(.numberPad)
                .limitText($chart.orderItem.phoneNumber, to: 11)
                .padding(.leading, 24)
                .kerning(0.5)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/930)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.bottom, 36)
            
            
            CustomText(title: "픽업 날짜/시간", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            
            //            CalendarView()
            //                .padding(.leading, 45)
            //                .padding(.bottom, 42)
            
            Spacer()
            
            Divider()
            
            ///케이크 사이즈
            CustomText(title: "케이크 사이즈", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            CustomButton(action:{chart.orderItem.cakeSize = "도시락"; size["도시락"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(size["도시락"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .overlay (alignment: .leading) {
                            HStack{
                                Image(size["도시락"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                VStack(alignment: .leading){
                                    CustomText(title: "도시락", textColor: .black, textWeight: .semibold, textSize: 18)
                                    CustomText(title: "지름 10Cm", textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                .padding()
                                
                                Spacer()
                                
                                CustomText(title: "20000원", textColor: .black, textWeight: .regular, textSize: 18)
                                    .padding(.trailing, 28)
                            }
                        }
                )
                .frame(height: 90)
                .padding(.bottom, 7)
                .onChange(of: [size["도시락"]]) { _ in
                    size["미니"] = false;
                    size["1호"] = false;
                    size["2호"] = false;
                    size["3호"] = false;
                }
            
            CustomButton(action: {chart.orderItem.cakeSize = "미니"; size["미니"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(size["미니"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .overlay (alignment: .leading) {
                            HStack{
                                Image(size["미니"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                VStack(alignment: .leading){
                                    CustomText(title: "미니", textColor: .black, textWeight: .semibold, textSize: 18)
                                    CustomText(title: "지름 12Cm", textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                .padding()
                                
                                Spacer()
                                
                                CustomText(title: "33000원", textColor: .black, textWeight: .regular, textSize: 18)
                                    .padding(.trailing, 28)
                            }
                        }
                )
                .frame(height: 90)
                .padding(.bottom, 7)
                .onChange(of: [size["미니"]]) { _ in
                    size["도시락"] = false;
                    size["1호"] = false;
                    size["2호"] = false;
                    size["3호"] = false;
                }
            
            CustomButton(action: {chart.orderItem.cakeSize = "1호"; size["1호"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(size["1호"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .overlay (alignment: .leading) {
                            HStack{
                                Image(size["1호"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                VStack(alignment: .leading){
                                    HStack {
                                        CustomText(title: "1호", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "2~4인분", textColor: .customGray, textWeight: .regular, textSize: 18)
                                    }
                                    CustomText(title: "원형 지름 기준 15Cm", textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                .padding()
                                
                                Spacer()
                                
                                CustomText(title: "45000원", textColor: .black, textWeight: .regular, textSize: 18)
                                    .padding(.trailing, 28)
                            }
                        }
                )
                .frame(height: 90)
                .padding(.bottom, 7)
                .onChange(of: [size["1호"]]) { _ in
                    size["미니"] = false;
                    size["도시락"] = false;
                    size["2호"] = false;
                    size["3호"] = false;
                }
            
            CustomButton(action: {chart.orderItem.cakeSize = "2호"; size["2호"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(size["2호"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .overlay (alignment: .leading) {
                            HStack{
                                Image(size["2호"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                VStack(alignment: .leading){
                                    HStack {
                                        CustomText(title: "2호", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "4~6인분", textColor: .customGray, textWeight: .regular, textSize: 18)
                                    }
                                    CustomText(title: "원형 지름 기준 18Cm", textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                .padding()
                                
                                Spacer()
                                
                                CustomText(title: "55000원", textColor: .black, textWeight: .regular, textSize: 18)
                                    .padding(.trailing, 28)
                            }
                        }
                )
                .frame(height: 90)
                .padding(.bottom, 7)
                .onChange(of: [size["2호"]]) { _ in
                    size["미니"] = false;
                    size["1호"] = false;
                    size["도시락"] = false;
                    size["3호"] = false;
                }
            
            CustomButton(action: {chart.orderItem.cakeSize = "3호"; size["3호"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(size["3호"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .overlay (alignment: .leading) {
                            HStack{
                                Image(size["3호"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                VStack(alignment: .leading){
                                    HStack {
                                        CustomText(title: "3호", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "6~8인분", textColor: .customGray, textWeight: .regular, textSize: 18)
                                    }
                                    CustomText(title: "원형 지름 기준 21Cm", textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                .padding()
                                
                                Spacer()
                                
                                CustomText(title: "65000원", textColor: .black, textWeight: .regular, textSize: 18)
                                    .padding(.trailing, 28)
                            }
                        }
                )
                .frame(height: 90)
                .padding(.bottom, 12)
                .onChange(of: [size["3호"]]) { _ in
                    size["미니"] = false;
                    size["1호"] = false;
                    size["2호"] = false;
                    size["도시락"] = false;
                }
            
            CustomText(title: "*디자인/그림/제작 난이도에 따라 추가 금액이 발생할 수 있습니다.", textColor: .customGray, textWeight: .semibold, textSize: 12)
                .padding(.leading,24)
                .padding(.bottom, 42)
            
            
            /// 시트 (빵)
            CustomText(title: "시트 (빵)", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            HStack {
                CustomButton(action: {chart.orderItem.sheet = "바닐라 시트"; sheet["바닐라 시트"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(sheet["바닐라 시트"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.leading, 24)
                            .padding(.trailing, 5.5)
                            .overlay {
                                HStack{
                                    Image(sheet["바닐라 시트"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                        .padding(.leading, 22)
                                    CustomText(title: "바닐라 시트", textColor: .black, textWeight: .semibold, textSize: 18)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [sheet["바닐라 시트"]]) { _ in
                        sheet["초코 시트"] = false;
                    }
                
                
                CustomButton(action: {chart.orderItem.sheet = "초코 시트"; sheet["초코 시트"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 6, trailing: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(sheet["초코 시트"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.trailing,24)
                            .padding(.leading, 5.5)
                            .overlay {
                                HStack{
                                    Image(sheet["초코 시트"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                        .padding(.leading, 22)
                                    CustomText(title: "초코 시트", textColor: .black, textWeight: .semibold, textSize: 18)
                                        .padding(.trailing, 52)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [sheet["초코 시트"]]) { _ in
                        sheet["바닐라 시트"] = false;
                    }
            }
            .padding(.bottom, 42)
            
            
            /// 속크림
            CustomText(title: "속크림", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            
            HStack {
                CustomButton(action: {chart.orderItem.cream = "크림치즈 프로스팅"; cream["크림치즈 프로스팅"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cream["크림치즈 프로스팅"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.leading, 24)
                            .padding(.trailing, 6)
                            .overlay {
                                HStack{
                                    Image(cream["크림치즈 프로스팅"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    CustomText(title: "크림치즈 \n프로스팅", textColor: .black, textWeight: .semibold, textSize: 18)
                                    
                                    
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [cream["크림치즈 프로스팅"]]) { _ in
                        cream["오레오"] = false;
                        cream["블루베리"] = false;
                        cream["초코"] = false;
                    }
                
                
                CustomButton(action: {chart.orderItem.cream = "오레오"; cream["오레오"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 6, trailing: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cream["오레오"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.trailing,24)
                            .padding(.leading, 6)
                            .overlay {
                                HStack{
                                    Image(cream["오레오"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                        .padding(.leading, 22)
                                    CustomText(title: "오레오", textColor: .black, textWeight: .semibold, textSize: 18)
                                        .padding(.trailing, 73)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [cream["오레오"]]) { _ in
                        cream["크림치즈 프로스팅"] = false;
                        cream["블루베리"] = false;
                        cream["초코"] = false;
                    }
            }
            .padding(.bottom, 12)
            
            HStack {
                CustomButton(action: {chart.orderItem.cream = "블루베리"; cream["블루베리"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cream["블루베리"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.leading, 24)
                            .padding(.trailing, 6)
                            .overlay {
                                HStack{
                                    Image(cream["블루베리"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    
                                    CustomText(title: "블루베리", textColor: .black, textWeight: .semibold, textSize: 18)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [cream["블루베리"]]) { _ in
                        cream["오레오"] = false;
                        cream["크림치즈 프로스팅"] = false;
                        cream["초코"] = false;
                    }
                
                
                CustomButton(action: {chart.orderItem.cream = "초코"; cream["초코"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 6, trailing: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(cream["초코"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.trailing,24)
                            .padding(.leading, 6)
                            .overlay {
                                HStack{
                                    Image(cream["초코"] ?? false ? "orderVectorTrue" : "orderVectorFalse")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    
                                    HStack{
                                        CustomText(title: "초코", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "(+2000원)", textColor: .black, textWeight: .regular, textSize: 12)
                                            .padding(.leading, -4)
                                    }
                                    .kerning(0.3)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [cream["초코"]]) { _ in
                        cream["오레오"] = false;
                        cream["블루베리"] = false;
                        cream["크림치즈 프로스팅"] = false;
                    }
            }
            .padding(.bottom, 12)
            
            
            CustomText(title: "*겉크림은 크림치즈생크림으로 만들어집니다.", textColor: .customGray, textWeight: .semibold, textSize: 14)
                .padding(.leading,24)
            
            CustomText(title: "*생크림은 100% 동물성 크림만 사용합니다.", textColor: .customGray, textWeight: .semibold, textSize: 14)
                .padding(.leading,24)
                .padding(.bottom, 42)
            
            
            
            
            /// 문구/글씨 색사
            CustomText(title: "문구/글씨 색상", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            
            TextField(" ex) 생일축하해 깐깐징어~!", text: $chart.orderItem.text, axis: .vertical)
                .modifier(LoginTextFieldModifier(width: 382, height: 90))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .padding(.leading, 24)
                .padding(.bottom, 42)
            
            
            /// 사진 첨부
            HStack {
                CustomText(title: "사진 첨부", textColor: .black, textWeight: .semibold , textSize: 18)
                    .padding(.leading, 24)
                
                PhotosPicker(selection: $photoVM.imageSelections, matching: .images) {
                    Image(systemName: "photo.badge.plus")
                        .foregroundColor(Color(UIColor.customBlue))
                }
                .padding(.leading, 280)
            }
            if photoVM.selectedImages.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.init(uiColor: .customGray), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.white)
                    .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 185/930)
                    .padding(.leading, 24)
                    .padding(.bottom, 42)
                    .overlay {
                        VStack {
                            Image(systemName: "photo")
                                .foregroundColor(Color(UIColor.customGray))
                            CustomText(title: "사진을 첨부해주세요", textColor: .customGray, textWeight: .regular, textSize: 18)
                            CustomText(title: "최대 4매까지 첨부가능합니다.", textColor: .customGray, textWeight: .regular, textSize: 14)
                        }
                    }
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(photoVM.selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 185/930)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 42)
            }
            
            CustomText(title: "보냉팩/백 추가", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            HStack {
                CustomButton(action: {chart.orderItem.icePack = IcePack.icePack; icepack["보냉팩"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 24, trailing: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(icepack["보냉팩"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.leading, 24)
                            .padding(.trailing, 5.5)
                            .overlay {
                                HStack{
                                    Image("VectorTrue")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 14)
                                        .padding(.leading, 16)
                                    HStack{
                                        CustomText(title: "보냉팩", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "(+1000원)", textColor: .black, textWeight: .regular, textSize: 12)
                                            .padding(.leading, -4)
                                    }
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [icepack["보냉팩"]]) { _ in
                        icepack["보냉백"] = false;
                    }
                
                
                CustomButton(action: {chart.orderItem.icePack = IcePack.iceBag; icepack["보냉백"]?.toggle()}, title: "", titleColor: .black, backgroundColor: .white, leading: 6, trailing: 24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(icepack["보냉백"] ?? false ? Color(uiColor: .customBlue) : Color(uiColor: .customLightgray))
                            .frame(height: 90)
                            .padding(.trailing,24)
                            .padding(.leading, 5.5)
                            .overlay {
                                HStack{
                                    Image("VectorTrue")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 14)
                                        .padding(.leading, 22)
                                    HStack{
                                        CustomText(title: "보냉백", textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: "(+5000원)", textColor: .black, textWeight: .regular, textSize: 12)
                                            .padding(.leading, -4)
                                    }
                                    .padding(.trailing, 42)
                                }
                            }
                    )
                    .frame(height: 90)
                    .onChange(of: [icepack["보냉백"]]) { _ in
                        icepack["보냉팩"] = false;
                    }
            }
            .padding(.bottom, 42)
            
            
            /// 추가 요청 사항
            CustomText(title: "추가 요청 사항", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)
            
            TextField(" 잘 부탁드립니다 ~", text: $chart.orderItem.comment, axis: .vertical)
                .modifier(LoginTextFieldModifier(width: 382, height: 90))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .padding(.leading, 24)
            
        }
    }
}


private struct BottomView: View {
    @ObservedObject var chart: OrderVM
    @ObservedObject var photoVM: PhotoPickerVm
    
    var body: some View {
        HStack {
            VStack {
                CustomText(title: "총 예상금액", textColor: .textFieldTextColor, textWeight: .semibold, textSize: 14)
                    .kerning(0.35)
                    .padding(.leading, 24)
                
                
                Text("\(chart.expectedPrice())원")
                    .font(.custom("Pretendard", size: 18))
                    .padding(.leading, 24)
                    .fontWeight(.semibold)
            }
            
            CustomButton(action: {chart.addOrderItem(); for i in 0...photoVM.selectedImages.count - 1 {photoVM.uploadPhoto(i, chart.orderItem.id)}}, title: "예약하기", titleColor: .white, backgroundColor: chart.isallcheck() ? .customBlue : .textFieldColor, leading: 110, trailing: 24)
                .kerning(0.45)
                .padding(.vertical, 12)
                .disabled(!chart.isallcheck())
        }
    }
}




struct LoginTextFieldModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .textInputAutocapitalization(.never)
            .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.init(uiColor: .customGray))
                    .foregroundColor(.white)
                    .frame(maxWidth: 382, maxHeight: 90)
            }
    }
}


extension View {
    func loginTextFieldModifier(width: CGFloat, height: CGFloat) -> some View {
        modifier(LoginTextFieldModifier(width: width, height: height))
    }
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
        self
            .onChange(of: text.wrappedValue) { _ in
                text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
            }
    }
}


#Preview {
    OrderView()
}
