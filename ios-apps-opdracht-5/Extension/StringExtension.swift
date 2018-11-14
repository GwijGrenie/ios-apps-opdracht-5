import Foundation

extension String {
    func containsOnlyLetters() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
}
