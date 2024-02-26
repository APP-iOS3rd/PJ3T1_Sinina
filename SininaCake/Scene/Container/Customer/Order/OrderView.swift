
import SwiftUI
import FirebaseStorage
import PhotosUI

struct OrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var OrderVM = OrderViewModel(orderItem: OrderItem(id: UUID().uuidString, email: "", date: Date(), orderTime: Date(), cakeSize: "도시락", sheet: "바닐라 시트", cream: "크림치즈 \n프로스팅", icePack: .none, name: "", phoneNumber: "", text: "", imageURL: [], comment: "", expectedPrice: 0, confirmedPrice: 0, status: .notAssign))
    @StateObject private var photoVM = PhotoPickerViewModel()
    @StateObject var loginVM = LoginViewModel.shared
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(showsIndicators: false){
                    infoView(orderData: OrderVM)
                    
                    //OrderCalendarView(orderData: OrderVM)
                    CustomerCalendarView(orderData: OrderVM)

                    OrderCakeView(orderData: OrderVM)
                    
                    OrderSheetView(orderData: OrderVM)
                    
                    OrderCreamView(orderData: OrderVM)
                    
                    OrderTextView(orderData: OrderVM)
                    
                    OrderPhotoView(photoVM: photoVM)
                    
                    OrderIcePackView(orderData: OrderVM)
                    
                    OrderCommentView(orderData: OrderVM)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("주문하기")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image("angle-left")
                            .foregroundStyle(Color.black)
                    })
                }
            }
        }
        
        BottomView(orderVM: OrderVM, photoVM: photoVM, loginVM: loginVM)
    }
}



// MARK: - infoView
struct infoView: View {
    @ObservedObject var orderData: OrderViewModel
    var body: some View {
        VStack(alignment:.leading){
            CustomText(title: "이름", textColor: .black, textWeight: .semibold , textSize: 18)
                .kerning(0.45)
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
            
            
            
            TextField("ex) 시니나...", text: $orderData.orderItem.name)
                .textFieldStyle(.plain)
                .font(.custom("Pretendard", fixedSize: 16))
                .fontWeight(.regular)
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                .submitLabel(.done)
                .scaledToFit()
                .minimumScaleFactor(0.2)
            
            
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/932)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                .padding(.bottom, (UIScreen.main.bounds.height) * 36/932)
            
            /// 휴대폰 번호
            CustomText(title: "휴대폰 번호", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
            
            
            
            TextField("010 -", text: $orderData.orderItem.phoneNumber)
                .textFieldStyle(.plain)
                .font(.custom("Pretendard", fixedSize: 16))
                .fontWeight(.regular)
                .submitLabel(.done)
                .keyboardType(.numberPad)
                .limitText($orderData.orderItem.phoneNumber, to: 11)
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                .kerning(0.5)
                .scaledToFit()
                .minimumScaleFactor(0.2)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/932)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                .padding(.bottom, (UIScreen.main.bounds.height) * 36/932)
            
        }
    }
}




// MARK: - OrderCalendarView
struct OrderCalendarView:View {
    @ObservedObject var orderData: OrderViewModel
    
    let excludedDays: IndexSet = [0, 1]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomText(title: "픽업 날짜/시간", textColor: .black, textWeight: .semibold , textSize: 18)
                    .padding(.leading,(UIScreen.main.bounds.width) * 24/430)
                
                Spacer()
                
                CustomText(title: dateToString(orderData.orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
                CustomText(title: dateToTime(orderData.orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
                    .padding(.trailing,(UIScreen.main.bounds.width) * 24/430 )
            }
            .scaledToFit()
            
            DatePicker (
                "Select Date",
                selection: $orderData.orderItem.date,
                in: Calendar.current.date(byAdding: .day, value: 3, to: Date())!...Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .font(.custom("Pretendard", fixedSize: 16))
            .fontWeight(.regular)
            .onChange(of: orderData.orderItem.date, perform: { value in
                let calendar = Calendar.current
                let day = calendar.component(.weekday, from: value)
                let hour = calendar.component(.hour, from: value)
                let minute = calendar.component(.minute, from: value)
                
                if hour < 11 || (hour == 11 && minute < 30) {
                    orderData.orderItem.date = calendar.date(bySettingHour: 11, minute: 30, second: 0, of: value) ?? Date()
                } else if hour > 19 || (hour == 19 && minute > 30) {
                    orderData.orderItem.date = calendar.date(bySettingHour: 19, minute: 30, second: 0, of: value) ?? Date()
                } else if minute % 30 == 0 {
                    orderData.orderItem.date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: value) ?? Date()
                }else if minute % 30 != 0 {
                    let roundedMinute = (minute / 30) * 30 + (minute % 30 > 15 ? 30 : 0)
                    orderData.orderItem.date = calendar.date(bySettingHour: hour, minute: roundedMinute, second: 0, of: value) ?? Date()
                }
                
                if excludedDays.contains(day - 1) {
                    orderData.orderItem.date = calendar.date(byAdding: .day, value: 1, to: value) ?? Date()
                }
            })
            .accentColor(Color(UIColor.customBlue))
            .padding(.bottom,(UIScreen.main.bounds.height) * 12/932 )
            .padding(.horizontal,UIScreen.UIWidth(12))
            
            CustomText(title: "*매주 일,월 정기휴무 입니다.", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                .padding(.leading,(UIScreen.main.bounds.width) * 24/430 )
            CustomText(title: "*정해진 픽업 시간을 꼭 지켜주세요, 픽업 당일 시간 변경은 불가합니다.", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                .padding(.horizontal,(UIScreen.main.bounds.width) * 24/430 )
                .padding(.bottom,(UIScreen.main.bounds.height) * 42/932)
        }
    }
}

// MARK: - OrderCakeView
struct OrderCakeView: View {
    @ObservedObject var orderData: OrderViewModel
    
    
    @State var selectedCakeIndex: Int?
    
    
    @State var orderCakeModel: [OrderCakeViewModel] = [
        OrderCakeViewModel(title: "도시락", sideTitle: "", bottomTitle: "지름 10cm", sizePricel: "20,000원", isOn: true),
        OrderCakeViewModel(title: "미니", sideTitle: "", bottomTitle: "지름 12cm", sizePricel: "33,000원", isOn: false),
        OrderCakeViewModel(title: "1호", sideTitle: "2~4인분", bottomTitle: "원형 지름 기준 15Cm", sizePricel: "45,000원", isOn: false),
        OrderCakeViewModel(title: "2호", sideTitle: "4~6인분", bottomTitle: "원형 지름 기준 18Cm", sizePricel: "55,000원", isOn: false),
        OrderCakeViewModel(title: "3호", sideTitle: "6~8인분", bottomTitle: "원형 지름 기준 21Cm", sizePricel: "65,000원", isOn: false)
    ]
    
    
    var body: some View {
        VStack(alignment:.leading){
            CustomText(title: "케이크 사이즈", textColor: .black, textWeight: .semibold , textSize: 18)
            VStack {
                ForEach(orderCakeModel.indices, id: \.self) { index in
                    Button(action: {
                        selectedCakeIndex = index
                        orderData.orderItem.cakeSize = orderCakeModel[index].title
                        print(orderData.orderItem.cakeSize)
                        updateSelection(index: index)
                    }, label: {
                        HStack{
                            Image(orderCakeModel[index].title == orderData.orderItem.cakeSize ? "orderVectorTrue" : "orderVectorFalse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/932)
                                .padding(.leading,(UIScreen.main.bounds.width) * 22/430 )
                                .padding(.trailing,(UIScreen.main.bounds.width) * 18/430 )
                            
                            VStack (alignment: .leading){
                                HStack{
                                    CustomText(title: orderCakeModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                    CustomText(title: orderCakeModel[index].sideTitle, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                                }
                                CustomText(title: orderCakeModel[index].bottomTitle, textColor: .customDarkGray, textWeight: .regular, textSize: 16)
                            }
                            
                            Spacer()
                            
                            CustomText(title: orderCakeModel[index].sizePricel, textColor: .black, textWeight: .regular, textSize: 18)
                                .padding(.trailing,(UIScreen.main.bounds.width) * 28/430)
                        }
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/932)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(orderCakeModel[index].title == orderData.orderItem.cakeSize ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                        )
                    })
                    
                    .padding(.bottom,(UIScreen.main.bounds.height) * 12/932)
                }
            }
            VStack(alignment: .leading){
                CustomText(title: "*디자인/그림/제작 난이도에 따라 추가 금액이 발생할 수 있습니다.", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                    .padding(.bottom,(UIScreen.main.bounds.height) * 42/932)
            }
        }
        .padding(.horizontal,(UIScreen.main.bounds.width) * 24/430)
    }
    private func updateSelection(index: Int) {
        for i in 0..<orderCakeModel.count {
            if i != index {
                orderCakeModel[i].isOn = false
            }
        }
    }
}

// MARK: - OrderSheetView
struct OrderSheetView: View {
    @ObservedObject var orderData: OrderViewModel
    
    @State var selectedSheetIndex: Int?
    
    @State var orderSheetModel: [OrderCakeViewModel] = [
        OrderCakeViewModel(title: "바닐라 시트", sideTitle: "", bottomTitle: "", sizePricel: "", isOn: true),
        OrderCakeViewModel(title: "초코 시트", sideTitle: "", bottomTitle: "", sizePricel: "", isOn: false),
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "시트 (빵)", textColor: .black, textWeight: .semibold , textSize: 18)
            
            HStack{
                ForEach(orderSheetModel.indices, id: \.self) { index in
                    Button(action: {
                        selectedSheetIndex = index
                        orderData.orderItem.sheet = orderSheetModel[index].title
                        print(orderData.orderItem.sheet)
                        updateSelection(index: index)
                    }, label: {
                        HStack{
                            Image(orderSheetModel[index].title == orderData.orderItem.sheet ? "orderVectorTrue" : "orderVectorFalse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/932)
                                .padding(.leading, (UIScreen.main.bounds.width) * 22/430)
                                .padding(.trailing,(UIScreen.main.bounds.width) * 7/430)
                            
                            VStack (alignment: .leading){
                                HStack{
                                    CustomText(title: orderSheetModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                }
                            }
                            
                            Spacer()
                            
                        }
                        .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/932)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(orderSheetModel[index].title == orderData.orderItem.sheet ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                        )
                    })
                    .padding(.bottom, (UIScreen.main.bounds.height) * 7/932)
                }
            }
            .padding(.bottom, (UIScreen.main.bounds.height) * 42/932)
            
        }
    }
    private func updateSelection(index: Int) {
        for i in 0..<orderSheetModel.count {
            if i != index {
                orderSheetModel[i].isOn = false
            }
        }
    }
}

// MARK: - OrderCreamView
struct OrderCreamView: View {
    @ObservedObject var orderData: OrderViewModel
    
    
    @State var selectedCreamIndex: Int?
    
    
    @State var orderCreamModel: [OrderCakeViewModel] = [
        OrderCakeViewModel(title: "크림치즈 \n프로스팅", sideTitle: "", bottomTitle: "", sizePricel: "", isOn: true),
        OrderCakeViewModel(title: "오레오", sideTitle: "", bottomTitle: "", sizePricel: "", isOn: false),
        OrderCakeViewModel(title: "블루베리", sideTitle: "", bottomTitle: "", sizePricel: "", isOn: false),
        OrderCakeViewModel(title: "초코", sideTitle: "(+2000원)", bottomTitle: "", sizePricel: "", isOn: false)
    ]
    
    
    
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "속크림", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, (UIScreen.main.bounds.width) * 24/430)
            
            HStack{
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(orderCreamModel.indices, id: \.self) { index in
                        Button(action: {
                            selectedCreamIndex = index
                            orderData.orderItem.cream = orderCreamModel[index].title
                            print(orderData.orderItem.cream)
                            updateSelection(index: index)
                        }, label: {
                            HStack{
                                Image(orderCreamModel[index].title == orderData.orderItem.cream ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/932)
                                    .padding(.leading, (UIScreen.main.bounds.width) * 22/430)
                                    .padding(.trailing, (UIScreen.main.bounds.width) * 7/430)
                                
                                VStack (alignment: .leading){
                                    HStack{
                                        CustomText(title: orderCreamModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: orderCreamModel[index].sideTitle, textColor: .black, textWeight: .regular, textSize: 16)
                                        
                                            .padding(.leading, (UIScreen.main.bounds.width) * -4/430)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/932)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(orderCreamModel[index].title == orderData.orderItem.cream ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                            )
                        })
                        
                        .padding(.bottom, (UIScreen.main.bounds.height) * 12/932)
                    }
                }
                .padding(.horizontal, (UIScreen.main.bounds.width) * 24/430)
            }
            VStack(alignment: .leading){
                CustomText(title: "*겉크림은 크림치즈생크림으로 만들어집니다.", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
                
                CustomText(title: "*생크림은 100% 동물성 크림만 사용합니다.", textColor: .customDarkGray, textWeight: .semibold, textSize: 12)
            }
            .padding(.leading, (UIScreen.main.bounds.width) * 24/430)
            .padding(.bottom, (UIScreen.main.bounds.height) * 42/932)
        }
    }
    
    private func updateSelection(index: Int) {
        for i in 0..<orderCreamModel.count {
            if i != index {
                orderCreamModel[i].isOn = false
            }
        }
    }
}


// MARK: - OrderTextView

struct OrderTextView: View {
    @ObservedObject var orderData: OrderViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "문구/글씨 색상", textColor: .black, textWeight: .semibold , textSize: 18)
            
            TextField("ex) 생일축하해 깐깐징어~!", text: $orderData.orderItem.text, axis: .vertical)
                .addLeftPadding(10)
                .modifier(LoginTextFieldModifier(width: (UIScreen.main.bounds.width) * 382/430,
                                                 height:  (UIScreen.main.bounds.height) * 90/430))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .scaledToFit()
                .minimumScaleFactor(0.2)
                .padding(.bottom,(UIScreen.main.bounds.height) * 42/932)
                .onAppear(perform : UIApplication.shared.hideKeyboard)
        }
    }
}


// MARK: - OrderPhotoView

private struct OrderPhotoView: View {
    @ObservedObject var photoVM: PhotoPickerViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
        VStack {
            HStack {
                CustomText(title: "사진 첨부", textColor: .black, textWeight: .semibold , textSize: 18)
                    .padding(.leading, (UIScreen.main.bounds.width) * 24/430)
                
                Spacer()
                
                PhotosPicker(selection: $photoVM.imageSelections, maxSelectionCount: 4, matching: .images) {
                    Image("OrderPhotoVector")
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width) * 24/430, height: (UIScreen.main.bounds.height) * 24/932)
                        .foregroundColor(Color(UIColor.customBlue))
                    
                }
                .padding(.trailing, (UIScreen.main.bounds.width) * 24/430)
            }
            if photoVM.selectedImages.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.init(uiColor: .customGray), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.white)
                    .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 130/932)
                    .overlay {
                        VStack() {
                            Image(systemName: "photo")
                                .foregroundColor(Color(UIColor.customGray))
                                .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 25/932)
                            CustomText(title: "사진을 첨부해주세요", textColor: .customGray, textWeight: .semibold, textSize: 16)
                            CustomText(title: "최대 4매까지 첨부가능합니다.", textColor: .customGray, textWeight: .semibold, textSize: 12)
                        }
                        .padding(.vertical, (UIScreen.main.bounds.height) * 26/932)
                    }
                    .padding(.bottom, (UIScreen.main.bounds.height) * 42/932)
            } else {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(photoVM.selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.customGray))
                                .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 185/932)
                                .foregroundStyle(.clear)
                                .overlay(
                                    Image(uiImage: photoVM.selectedImages[index])
                                        .resizable()
                                        .frame(width: (UIScreen.main.bounds.width) * 185/430 - 20, height: (UIScreen.main.bounds.height) * 185/932 - 20)
                                        .scaledToFit()
                                )
                            
                            Button(action: {
                                photoVM.selectedImages.remove(at: index)
                                photoVM.imageSelections.remove(at: index)
                                print(photoVM.selectedImages.count)
                                print(photoVM.imageSelections.count)
                            }) {
                                Image("redX")
                                    .resizable()
                                    .frame(width: UIScreen.UIWidth(24), height: UIScreen.UIHeight(24))
                                    .padding(UIScreen.UIWidth(12))
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, (UIScreen.main.bounds.height) * 42/932)
            }
        }
    }
}

// MARK: - OrderIcePackView

struct OrderIcePackView: View {
    @ObservedObject var orderData: OrderViewModel
    
    @State var selectedIcePackIndex: Int?
    
    @State var orderIcePackModel: [OrderCakeViewModel] = [
        OrderCakeViewModel(title: "보냉팩", sideTitle: "(+1000원)", bottomTitle: "", sizePricel: "", isOn: true),
        OrderCakeViewModel(title: "보냉백", sideTitle: "(+5000원)", bottomTitle: "", sizePricel: "", isOn: false),
    ]
    
    @State var isClicked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                CustomText(title: "보냉팩/ 백 추가", textColor: .black, textWeight: .semibold , textSize: 18)
                Button(action: {
                    isClicked.toggle()
                    print(index)
                }) {
                    Image("info 1")
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width) * 14/430, height: (UIScreen.main.bounds.height) * 14/932)
                        .foregroundColor(.red)
                        .padding(8)
                }

                .fullScreenCover(isPresented: $isClicked, content: {
                    ZStack {
                        HStack{
                            Image("IcePack")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 202/932)
                            Image("IceBag")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 202/932)
                        }
                    
                        Button(action: {
                            isClicked.toggle()
                        }) {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width) * 22/430, height: (UIScreen.main.bounds.height) * 22/932)
                                .foregroundColor(.red)
                                .padding(8)
                        }
                        .offset(x: (UIScreen.main.bounds.width) * 185/430 / 2 + 87 , y: -(UIScreen.main.bounds.height) * 202/932 / 2 - 17)
                    }
                })
            }
            HStack{
                ForEach(orderIcePackModel.indices, id: \.self) { index in
                    ZStack {
                        Button(action: {
                            if selectedIcePackIndex == index {
                                selectedIcePackIndex = nil
                                orderData.orderItem.icePack = .none
                            } else {
                                selectedIcePackIndex = index
                                orderData.orderItem.icePack = stringToIcePack(orderIcePackModel[index].title)
                            }
                            print(orderData.orderItem.icePack)
                            updateSelection(index: index)
                        }, label: {
                            HStack{
                                Image(orderIcePackModel[index].title == icePackToString(orderData.orderItem.icePack) ? "orderVectorTrue" : "orderVectorFalse")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/932)
                                    .padding(.leading, (UIScreen.main.bounds.width) * 16/430)
                                
                                VStack (alignment: .leading){
                                    HStack{
                                        CustomText(title: orderIcePackModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: orderIcePackModel[index].sideTitle, textColor: .black, textWeight: .regular, textSize: 16)
                                            .padding(.leading, -4)
                                            .kerning(0.3)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/932)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(orderIcePackModel[index].title == icePackToString(orderData.orderItem.icePack) ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                                    .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/932)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(disableSelection(for: index) ? Color(UIColor.customGray) : .white)
                                    )
                            )
              
                            .kerning(0.3)
                        })
                        .padding(.bottom, 7)
                        .disabled(disableSelection(for: index))
                        .onChange(of: orderData.orderItem.cakeSize) { _ in
                            selectedIcePackIndex = nil
                            orderData.orderItem.icePack = .none
                        }
                    }
                }
            }
            .padding(.bottom, 42)
        }
    }
    private func stringToIcePack(_ icePack: String) -> IcePack {
        if icePack == "보냉백" {
            return IcePack.iceBag
        } else if icePack == "보냉팩" {
            return IcePack.icePack
        } else {
            return IcePack.none
        }
    }
    
    private func disableSelection(for index: Int) -> Bool {
        if orderData.orderItem.cakeSize != "도시락" {
            return orderIcePackModel[index].title != "보냉백"
        } else {
            return false
        }
    }
    
    private func isIcePack(for index: Int) -> Bool {
        if index == 0 {
            return true
        } else {
            return false
        }
    }
    
    private func updateSelection(index: Int) {
        for i in 0..<orderIcePackModel.count {
            if i != index {
                orderIcePackModel[i].isOn = false
            }
        }
    }
}


// MARK: - OrderCommentView
struct OrderCommentView: View {
    @ObservedObject var orderData: OrderViewModel
    
    
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "추가 요청 사항", textColor: .black, textWeight: .semibold , textSize: 18)
            
            TextField("잘 부탁드립니다 ~", text: $orderData.orderItem.comment, axis: .vertical)
                .addLeftPadding(10)
                .modifier(LoginTextFieldModifier(width: (UIScreen.main.bounds.width) * 382/430, height:  (UIScreen.main.bounds.height) * 90/430))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .scaledToFit()
                .minimumScaleFactor(0.2)
                .padding(.bottom, (UIScreen.main.bounds.height) * 42/932)
                .onAppear(perform : UIApplication.shared.hideKeyboard)
        }
    }
}

// MARK: - BottomView
private struct BottomView: View {
    @ObservedObject var orderVM: OrderViewModel
    @ObservedObject var photoVM: PhotoPickerViewModel
    @ObservedObject var loginVM: LoginViewModel
    @State var clickedConfirm = false
    
    var body: some View {
        HStack {
            VStack {
                CustomText(title: "총 예상금액", textColor: .customDarkGray, textWeight: .semibold, textSize: 14)
                    .kerning(0.35)
                
                CustomText(title: "\(orderVM.expectedPrice())원", textColor: .black, textWeight: .semibold, textSize: 18)
            }
            .padding(.leading, (UIScreen.main.bounds.width) * 24/430)
            
            CustomButton(action: {
                //                    defer {
                clickedConfirm = true
                //                    };
                for i in 0...photoVM.selectedImages.count - 1 {
                    photoVM.uploadPhoto(i, orderVM.orderItem.id);
                    orderVM.imgURL(i)
                };
                orderVM.orderItem.expectedPrice = orderVM.expectedPrice();
                orderVM.orderItem.email = loginVM.loginUserEmail ?? ""},
                         title: "예약하기",
                         titleColor: .white,
                         backgroundColor: orderVM.isallcheck() && !photoVM.selectedImages.isEmpty ? .customBlue : .customGray,
                         leading: 110, trailing: 24)
            .kerning(0.45)
            .padding(.vertical, 12)
            .disabled(!orderVM.isallcheck() || photoVM.selectedImages.isEmpty)
            .navigationDestination(isPresented: $clickedConfirm, destination: {
                UserConfirmOrderDetailView(orderVM: orderVM, photoVM: photoVM)})
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
            .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/932)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.init(uiColor: .customGray))
                    .foregroundColor(.white)
                    .frame(maxWidth: (UIScreen.main.bounds.width) * 382/430, maxHeight: (UIScreen.main.bounds.height) * 90/932)
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
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    func hideKeyboard() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension TextField {
    func addLeftPadding(_ width: CGFloat) -> some View {
            return self.padding(.leading, width)
        }
}

#Preview {
    OrderView()
}
