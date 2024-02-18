
import SwiftUI
import FirebaseStorage
import PhotosUI

struct OrderView: View {
    @StateObject var OrderVM = OrderViewModel(orderItem: OrderItem(id: UUID().uuidString, email: "", date: Date(), orderTime: Date(), cakeSize: "", sheet: "", cream: "", icePack: .none, name: "", phoneNumber: "", text: "", imageURL: ["","","",""], comment: "", expectedPrice: 0, confirmedPrice: 0, status: .notAssign))
    @StateObject private var photoVM = PhotoPickerViewModel()
    @StateObject var loginVM = LoginViewModel.shared



    var body: some View {
        NavigationView{
            VStack{
                ScrollView(showsIndicators: false){
                    infoView(orderData: OrderVM)

                    OrderCalendarView(orderData: OrderVM)

                    OrderCakeView(orderData: OrderVM)

                    OrderSheetView(orderData: OrderVM)

                    OrderCreamView(orderData: OrderVM)

                    OrderTextView(orderData: OrderVM)

                    OrderPhotoView(photoVM: photoVM)

                    OrderCommentView(orderData: OrderVM)
                }
            }
            .navigationTitle("주문하기")
            .navigationBarTitleDisplayMode(.inline)
        }
        BottomView(orderData: OrderVM, photoVM: photoVM, loginVM: loginVM)
    }
}



// MARK: - infoView
struct infoView: View {
    @ObservedObject var orderData: OrderViewModel
    var body: some View {
        VStack(alignment:.leading){
            CustomText(title: "이름", textColor: .black, textWeight: .semibold , textSize: 18)
                .kerning(0.45)
                .padding(.leading, 24)

            TextField("ex) 시니나...", text: $orderData.orderItem.name)
                .textFieldStyle(.plain)
                .padding(.leading, 24)
                .submitLabel(.done)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/930)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.leading, 24)
                .padding(.bottom, 36)

            /// 휴대폰 번호
            CustomText(title: "휴대폰 번호", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)

            TextField("010 -", text: $orderData.orderItem.phoneNumber)
                .textFieldStyle(.plain)
                .submitLabel(.done)
                .limitText($orderData.orderItem.phoneNumber, to: 11)
                .padding(.leading, 24)
                .kerning(0.5)


            Rectangle()
                .foregroundColor(.clear)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 1/930)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .padding(.leading, 24)
                .padding(.bottom, 36)
        }
    }
}



// MARK: - OrderCalendarView
struct OrderCalendarView:View {
    @ObservedObject var orderData: OrderViewModel

    let excludedDays: IndexSet = [0, 1]

    var body: some View {
        HStack {
            CustomText(title: "픽업 날짜/시간", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)

            Spacer()

            CustomText(title: dateToString(orderData.orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
            CustomText(title: dateToTime(orderData.orderItem.date), textColor: .black, textWeight: .semibold, textSize: 18)
                .padding(.trailing, 24)
        }
        .scaledToFit()

        DatePicker (
            "Select Date",
            selection: $orderData.orderItem.date,
            in: Calendar.current.date(byAdding: .day, value: 3, to: Date())!...Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
            displayedComponents: [.date, .hourAndMinute]
        )
        .datePickerStyle(.graphical)
        .onChange(of: orderData.orderItem.date, perform: { value in
            let calendar = Calendar.current
            let day = calendar.component(.weekday, from: value)
            let hour = calendar.component(.hour, from: value)
            let minute = calendar.component(.minute, from: value)

            if hour < 11 || (hour == 11 && minute < 30) {
                orderData.orderItem.date = calendar.date(bySettingHour: 11, minute: 30, second: 0, of: value) ?? Date()
            } else if hour > 19 || (hour == 19 && minute > 30) {
                orderData.orderItem.date = calendar.date(bySettingHour: 19, minute: 30, second: 0, of: value) ?? Date()
            } else if minute % 30 != 0 {
                let roundedMinute = (minute / 30) * 30 + (minute % 30 > 15 ? 30 : 0)
                orderData.orderItem.date = calendar.date(bySettingHour: hour, minute: roundedMinute, second: 0, of: value) ?? Date()
            }

            if excludedDays.contains(day - 1) {
                orderData.orderItem.date = calendar.date(byAdding: .day, value: 1, to: value) ?? Date()
            }
        })
        .accentColor(Color(UIColor.customBlue))

        VStack(alignment: .leading) {
            CustomText(title: "*매주 일,월 정기휴무 입니다.", textColor: .customGray, textWeight: .semibold, textSize: 14)

            CustomText(title: "*정해진 픽업 시간을 꼭 지켜주세요, 픽업 당일 시간 변경은 불가합니다.", textColor: .customGray, textWeight: .semibold, textSize: 14)
                .padding(.bottom, 42)
        }
    }
}


// MARK: - OrderTextView

struct OrderTextView: View {
    @ObservedObject var orderData: OrderViewModel
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "문구/글씨 색상", textColor: .black, textWeight: .semibold , textSize: 18)

            TextField(" ex) 생일축하해 깐깐징어~!", text: $orderData.orderItem.text, axis: .vertical)
                .modifier(LoginTextFieldModifier(width: 382, height: 90))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .padding(.bottom, 42)
                .submitLabel(.done)
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
                                .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                .padding(.leading, 22)
                                .padding(.trailing, 18)

                            VStack (alignment: .leading){
                                HStack{
                                    CustomText(title: orderCakeModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                    CustomText(title: orderCakeModel[index].sideTitle, textColor: .customGray, textWeight: .regular, textSize: 16)
                                }
                                CustomText(title: orderCakeModel[index].bottomTitle, textColor: .customGray, textWeight: .regular, textSize: 16)
                            }

                            Spacer()

                            CustomText(title: orderCakeModel[index].sizePricel, textColor: .black, textWeight: .regular, textSize: 18)
                                .padding(.trailing, 28)
                        }
                        .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(orderCakeModel[index].title == orderData.orderItem.cakeSize ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                        )
                    })
                    .padding(.bottom, 7)
                }
            }
            VStack(alignment: .leading){
                CustomText(title: "*디자인/그림/제작 난이도에 따라 추가 금액이 발생할 수 있습니다.", textColor: .customGray, textWeight: .semibold, textSize: 12)
                    .padding(.bottom, 42)
            }
        }
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
                                .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                .padding(.leading, 22)
                                .padding(.trailing, 14)

                            VStack (alignment: .leading){
                                HStack{
                                    CustomText(title: orderSheetModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                }
                            }

                            Spacer()

                        }
                        .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/930)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(orderSheetModel[index].title == orderData.orderItem.sheet ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                        )
                    })
                    .padding(.bottom, 7)
                }
            }
            .padding(.bottom, 42)
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
                .padding(.leading, 24)
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
                                    .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 28/930)
                                    .padding(.leading, 22)
                                    .padding(.trailing, 14)

                                VStack (alignment: .leading){
                                    HStack{
                                        CustomText(title: orderCreamModel[index].title, textColor: .black, textWeight: .semibold, textSize: 18)
                                        CustomText(title: orderCreamModel[index].sideTitle, textColor: .black, textWeight: .regular, textSize: 16)
                                            .padding(.leading, -4)
                                    }
                                }

                                Spacer()

                            }
                            .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 90/930)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(orderCreamModel[index].title == orderData.orderItem.cream ? Color(uiColor: .customBlue) : Color(uiColor: .customGray))
                            )
                        })
                        .padding(.bottom, 7)
                    }
                }
                .padding(.horizontal, 24)
            }
            VStack(alignment: .leading){
                CustomText(title: "*겉크림은 크림치즈생크림으로 만들어집니다.", textColor: .customGray, textWeight: .semibold, textSize: 16)

                CustomText(title: "*생크림은 100% 동물성 크림만 사용합니다.", textColor: .customGray, textWeight: .semibold, textSize: 16)
                    .padding(.bottom, 42)
            }
            .padding(.leading, 24)
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


// MARK: - OrderPhotoView
private struct OrderPhotoView: View {
    @ObservedObject var photoVM: PhotoPickerViewModel

    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]


    var body: some View {
        HStack {
            CustomText(title: "사진 첨부", textColor: .black, textWeight: .semibold , textSize: 18)
                .padding(.leading, 24)

            Spacer()

            PhotosPicker(selection: $photoVM.imageSelections, maxSelectionCount: 4, matching: .images) {
                Image(systemName: "photo.badge.plus")
                    .foregroundColor(Color(UIColor.customBlue))
            }
            .padding(.trailing, 24)

        }
        if photoVM.selectedImages.isEmpty {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.init(uiColor: .customGray), style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.white)
                .frame(width: (UIScreen.main.bounds.width) * 382/430, height: (UIScreen.main.bounds.height) * 185/930)
                .padding(.bottom, 42)
                .overlay {
                    VStack {
                        Image(systemName: "photo")
                            .foregroundColor(Color(UIColor.customGray))
                            .frame(width: (UIScreen.main.bounds.width) * 28/430, height: (UIScreen.main.bounds.height) * 25/930)
                            .padding(.bottom, 8)
                        CustomText(title: "사진을 첨부해주세요", textColor: .customGray, textWeight: .semibold, textSize: 16)
                        CustomText(title: "최대 4매까지 첨부가능합니다.", textColor: .customGray, textWeight: .semibold, textSize: 12)
                    }
                }
        } else {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(photoVM.selectedImages, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width) * 185/430, height: (UIScreen.main.bounds.height) * 185/930)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                }
            }
            .padding()
            .padding(.bottom, 42)
        }
    }
}


// MARK: - OrderCommentView

struct OrderCommentView: View {
    @ObservedObject var orderData: OrderViewModel
    var body: some View {
        VStack(alignment: .leading){
            CustomText(title: "추가 요청 사항", textColor: .black, textWeight: .semibold , textSize: 18)

            TextField(" 잘 부탁드립니다 ~", text: $orderData.orderItem.comment, axis: .vertical)
                .modifier(LoginTextFieldModifier(width: 382, height: 90))
                .font(.custom("Pretendard", size: 16))
                .fontWeight(.regular)
                .submitLabel(.done)
        }
    }
}




// MARK: - BottomView
private struct BottomView: View {
    @ObservedObject var orderData: OrderViewModel
    @ObservedObject var photoVM: PhotoPickerViewModel
    @ObservedObject var loginVM: LoginViewModel

    var body: some View {
        HStack {
            VStack {
                CustomText(title: "총 예상금액", textColor: .textFieldTextColor, textWeight: .semibold, textSize: 14)
                    .kerning(0.35)
                    .padding(.leading, 24)


                Text("\(orderData.expectedPrice())원")
                    .font(.custom("Pretendard", size: 18))
                    .padding(.leading, 24)
                    .fontWeight(.semibold)


            }

            CustomButton(action: {defer {orderData.addOrderItem()}; for i in 0...photoVM.selectedImages.count - 1 {photoVM.uploadPhoto(i, orderData.orderItem.id); orderData.imgURL(i)}; orderData.orderItem.expectedPrice = orderData.expectedPrice(); orderData.orderItem.email = loginVM.loginUserEmail ?? ""}, title: "예약하기", titleColor: .white, backgroundColor: orderData.isallcheck() && !photoVM.selectedImages.isEmpty ? .customBlue : .textFieldColor, leading: 110, trailing: 24)
                .kerning(0.45)
                .padding(.vertical, 12)
                .disabled(!orderData.isallcheck() || photoVM.selectedImages.isEmpty)


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
                    .frame(maxWidth: (UIScreen.main.bounds.width) * 382/430, maxHeight: (UIScreen.main.bounds.height) * 90/930)
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
