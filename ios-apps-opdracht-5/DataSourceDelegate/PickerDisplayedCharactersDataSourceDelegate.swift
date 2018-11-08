import Foundation
import UIKit

class PickerDisplayedCharactersDataSourceDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static let displayedCharacters: [String] = ["-", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerDisplayedCharactersDataSourceDelegate.displayedCharacters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerDisplayedCharactersDataSourceDelegate.displayedCharacters[row]
    }
    
}
