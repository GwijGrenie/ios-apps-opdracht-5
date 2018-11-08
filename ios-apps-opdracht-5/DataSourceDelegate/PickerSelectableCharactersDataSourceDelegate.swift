import Foundation
import UIKit

class  PickerSelectableCharactersDataSourceDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    static let selectableCharacters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PickerSelectableCharactersDataSourceDelegate.selectableCharacters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PickerSelectableCharactersDataSourceDelegate.selectableCharacters[row]
    }
}
