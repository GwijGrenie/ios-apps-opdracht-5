import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var pickerCollectionLetters: [UIPickerView]!
    @IBOutlet weak var pickerUserSelectedLetter: UIPickerView!
    @IBOutlet weak var buttonPlayLetter: UIButton!
    
    private var alertStartGame: UIAlertController?
    
    private let maximumNumberOfAttempts = 11
    
    private let selectableCharacters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private let notFoundCharacter: String = "-"
    private var allCharacters: [String] = [String]()
    
    private var selectedWord: String = String()
    private var galgjeEngine: GalgjeEngine! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allCharacters.append(notFoundCharacter)
        allCharacters = allCharacters + selectableCharacters
        
        pickerCollectionLetters.forEach({picker in
            picker.delegate = self
            picker.dataSource = self
        })
        
        pickerUserSelectedLetter.delegate = self
        pickerUserSelectedLetter.dataSource = self
        
        initStartGameAlert()
    }
    
    @IBAction func onTapStartGame(_ sender: UITapGestureRecognizer) {
       showStartGameDialog()
    }
    
    @IBAction func onTouchUpInsideButtonPlayLetter(_ sender: UIButton) {
        let currentSelectedCharacter = selectableCharacters[pickerUserSelectedLetter.selectedRow(inComponent: 0)]
        let resultOfAttempt = galgjeEngine.attempt(Letter: Character(currentSelectedCharacter))
        
        if resultOfAttempt.IsInWord {
            resultOfAttempt.AtPositions.forEach({position in
                pickerCollectionLetters[position].selectRow(allCharacters.firstIndex(of: currentSelectedCharacter)!, inComponent: 0, animated: true)
            })
        } else {
            
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerUserSelectedLetter {
            return selectableCharacters.count
        }
        
        return allCharacters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerUserSelectedLetter {
            return selectableCharacters[row]
        }
        
        return allCharacters[row]
    }
}

extension ViewController {
    
    private func initStartGameAlert() {
        alertStartGame = UIAlertController(title: "GALGJE", message: "Geef een woord van 6 letters...", preferredStyle: UIAlertController.Style.alert)
        alertStartGame!.addAction(UIAlertAction(title: "Annuleer", style: UIAlertAction.Style.cancel, handler: nil))
        alertStartGame!.addTextField(configurationHandler: { textField in
            textField.placeholder = "Woord..."
        })
        alertStartGame!.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.onSelectedWord(self.alertStartGame!)
        }))
    }
    
    private func showStartGameDialog() {
        guard let unwrappedAlertStartGame = alertStartGame else {
            return
        }
        
        present(unwrappedAlertStartGame, animated: true)
    }
    
    private func onSelectedWord(_ alert: UIAlertController) {
        let word = alert.textFields?.first?.text
        let validationResult = self.validateSelectedWord(word)
        
        if validationResult.isValid {
            galgjeEngine = GalgjeEngine(WithWord: word!, WithMaximumNumberOfAttempts: maximumNumberOfAttempts)
            isLetterSelectionEnabled(true)
        } else {
            // TODO: ¯\_(ツ)_/¯
            // nothing for now...
            // maybe show error...
            print(validationResult.error!)
        }
    }
    
    private func validateSelectedWord(_ word: String?) -> (isValid: Bool, error: String?) {
        
        guard let unwrappedWord = word else {
            return ( false, "word must not be empty" )
        }
        
        if unwrappedWord.isEmpty {
            return ( false, "word must not be empty" )
        }
        
        if unwrappedWord.count > 6 {
            return ( false, "word cannot be greater than 6 characters" )
        }
        
        return ( true, nil )
    }
}

extension ViewController {
    
    private func isLetterSelectionEnabled() -> Bool {
        return pickerUserSelectedLetter.isUserInteractionEnabled
    }
    
    private func isLetterSelectionEnabled(_ isEnabled: Bool) {
        pickerUserSelectedLetter.isUserInteractionEnabled = isEnabled
        buttonPlayLetter.isUserInteractionEnabled = isEnabled
    }
    
}
