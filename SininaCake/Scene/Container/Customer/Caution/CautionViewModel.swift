
import Foundation

func isAllChecked(_ pickUp: Bool, _ cakeCaution: Bool, _ instaUpload: Bool) -> Bool {
    if (pickUp && cakeCaution && instaUpload == true) {
        return true
    } else {
        return false
    }
}

