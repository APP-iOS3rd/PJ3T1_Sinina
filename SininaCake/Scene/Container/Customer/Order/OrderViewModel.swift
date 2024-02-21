

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseDatabaseSwift
import Combine
import _PhotosUI_SwiftUI


class OrderViewModel: ObservableObject {
    @Published var orderItem: OrderItem

    init(orderItem: OrderItem) {
        self.orderItem = orderItem
    }


    func addOrderItem() {
        let db = Firestore.firestore()

        /* let collection: Void =*/ db.collection("CurrentOrders").document(orderItem.id).setData([
            "comment": orderItem.comment,
            "cream": orderItem.cream,
            "date": orderItem.date,
            "email": orderItem.email,
            "expectedPrice": orderItem.expectedPrice,
            "icePack": icePackToString(orderItem.icePack),
            "id": orderItem.id,
            "imageURL": orderItem.imageURL,
            "name": orderItem.name,
            "orderTime": orderItem.orderTime,
            "phoneNumber": orderItem.phoneNumber,
            "sheet": orderItem.sheet,
            "size": orderItem.cakeSize,
            "text": orderItem.text,
            "status": statusToString(orderItem.status)
        ])
        /*let collection2: Void =*/ db.collection("Users").document(orderItem.email).collection("Orders").document(orderItem.id).setData([
            "comment": orderItem.comment,
            "cream": orderItem.cream,
            "date": orderItem.date,
            "email": orderItem.email,
            "expectedPrice": orderItem.expectedPrice,
            "icePack": icePackToString(orderItem.icePack),
            "id": orderItem.id,
            "imageURL": orderItem.imageURL,
            "name": orderItem.name,
            "orderTime": orderItem.orderTime,
            "phoneNumber": orderItem.phoneNumber,
            "sheet": orderItem.sheet,
            "size": orderItem.cakeSize,
            "text": orderItem.text,
            "status": statusToString(orderItem.status)
        ])
    }

    func expectedPrice() -> Int {
        var price = 0

        switch orderItem.cakeSize {
        case "도시락" :
            price += 20000
        case "미니" :
            price += 33000
        case "1호" :
            price += 45000
        case "2호" :
            price += 55000
        case "3호" :
            price += 65000
        default :
            price += 0
        }

        if orderItem.cream == "초코" {
            price += 2000
        }

        switch orderItem.icePack {
        case .none:
            price += 0
        case .icePack:
            price += 1000
        case .iceBag:
            price += 5000
        }
        return price
    }

    func isallcheck() -> Bool {
        var check: Bool = false

        if orderItem.cakeSize.isEmpty || orderItem.cream.isEmpty || orderItem.phoneNumber.isEmpty || orderItem.sheet.isEmpty || orderItem.name.isEmpty || orderItem.text.isEmpty  {
            check = false
        } else {
            check = true
        }

        return check
    }

    func imgURL(_ i: Int) {
        orderItem.imageURL.append("\(i + 1)")
    }

}

class OrderCakeViewModel: ObservableObject, Hashable {

    static func == (lhs: OrderCakeViewModel, rhs: OrderCakeViewModel) -> Bool {
        return lhs.title == rhs.title && lhs.sideTitle == rhs.sideTitle && lhs.bottomTitle == rhs.bottomTitle && lhs.sizePricel == rhs.sizePricel
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(sideTitle)
        hasher.combine(bottomTitle)
        hasher.combine(sizePricel)
    }

    var title: String
    var sideTitle: String
    var bottomTitle: String
    var sizePricel: String
    @Published var isOn: Bool

    init(title: String, sideTitle: String, bottomTitle: String, sizePricel: String, isOn: Bool) {
        self.title = title
        self.sideTitle = sideTitle
        self.bottomTitle = bottomTitle
        self.sizePricel = sizePricel
        self.isOn = isOn
    }

    func toggleIsOn() {
        isOn.toggle()
    }
}

class TextLimiter: ObservableObject {
    private let limit: Int

    init(limit: Int) {
        self.limit = limit
    }

    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}


@MainActor
class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }


    func setImages(from selections: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            selectedImages = images
        }
    }

    func uploadPhoto(_ i: Int,_ path: String) {

        guard let selectedimagesData = selectedImages[i].pngData() else { return }

        let storageRef = Storage.storage().reference()

        let fileRef = storageRef.child("\(path)/\(i + 1)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"

        if !selectedimagesData.isEmpty {
            let uploadTask = fileRef.putData(selectedimagesData, metadata: metadata) { metadata,
                error in

                if error == nil && metadata != nil {
                    print("Success!")
                }
            }
        } else {

        }
    }

    func photoCheck() -> Bool{
        if selectedImages.isEmpty {
            return true
        } else {
            return false
        }
    }

}

func statusToString(_ status: OrderStatus) -> String {
    switch status {
    case .assign:
        return "승인"
    case .notAssign:
        return "미승인"
    case .complete:
        return "완료"
    }
}

func icePackToString(_ icePack: IcePack) -> String {
    switch icePack {
    case .none:
        return "없음"
    case .icePack:
        return "보냉팩"
    case .iceBag:
        return "보냉백"
    }
}


func dateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko-KR")
    dateFormatter.dateFormat = "yyyy/MM/dd(E)"

    let dateString = dateFormatter.string(from: date)
    return dateString
}

func dateToTime(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    let timeString = dateFormatter.string(from: date)
    return timeString
}


