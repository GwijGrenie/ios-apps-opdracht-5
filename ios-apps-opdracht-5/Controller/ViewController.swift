import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerDisplayedCharacters: UIPickerView!
    @IBOutlet weak var pickerUserSelectedLetter: UIPickerView!
    @IBOutlet weak var buttonPlayLetter: UIButton!
    @IBOutlet weak var imageGallows: UIImageView!
    @IBOutlet weak var textBoxCorrectLetterHistory: UITextView!
    
    private let maximumNumberOfAttempts: Int = 11
    private var correctLetters: [String] = ["_", "_", "_", "_", "_", "_"]
    
    private var galgjeEngine: GalgjeEngine! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGallows.isHidden = true
    }
    
    @IBAction func onTapStartGame(_ sender: UITapGestureRecognizer) {
       showStartGameDialog()
    }
    
    @IBAction func onTouchUpInsideButtonPlayLetter(_ sender: UIButton) {
        
        let currentSelectedCharacter = PickerSelectableCharactersDataSourceDelegate.selectableCharacters[pickerUserSelectedLetter.selectedRow(inComponent: 0)]
        
        if galgjeEngine.currentAttemptedLetters.contains(currentSelectedCharacter) {
            return
        }
        
        let resultOfAttempt = galgjeEngine.attempt(Letter: Character(currentSelectedCharacter))
        
        if resultOfAttempt.IsInWord {
            resultOfAttempt.AtPositions.forEach({position in
                
                let indexOfCharacter = PickerDisplayedCharactersDataSourceDelegate.displayedCharacters.firstIndex(of: currentSelectedCharacter)!
                pickerDisplayedCharacters.selectRow(indexOfCharacter, inComponent: position, animated: true)
                correctLetters[position] = currentSelectedCharacter
            })
            updateCorrectLettersHistory()
        } else {
            let currentWrongAttempts = galgjeEngine.currentWrongAttempts
            imageGallows.isHidden = false
            imageGallows.image = UIImage(named: "galgje" + String(currentWrongAttempts))
        }
    }
}

extension ViewController: GalgjeEngineDelegate {
    
    func onGameWon() {
        showAlert("Gewonnen", "Proficiat")
        isLetterSelectionEnabled(false)
    }
    
    func onGameLost() {
        showAlert("Verloren", "Jammer!")
        isLetterSelectionEnabled(false)
    }
}

extension ViewController {
    
    private func showStartGameDialog() {
        let alertStartGame: UIAlertController = UIAlertController(title: "GALGJE", message: "Geef een woord van 6 letters...", preferredStyle: UIAlertController.Style.alert)
        alertStartGame.addAction(UIAlertAction(title: "Annuleer", style: UIAlertAction.Style.cancel, handler: nil))
        alertStartGame.addTextField(configurationHandler: { textField in
            textField.placeholder = "Woord..."
        })
        alertStartGame.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.onSelectedWord(alertStartGame)
        }))
        
        present(alertStartGame, animated: true)
    }
    
    private func onSelectedWord(_ alert: UIAlertController) {
        let word = alert.textFields?.first?.text
        let validationResult = self.validateSelectedWord(word)
        
        if validationResult.isValid {
            resetPicker(pickerUserSelectedLetter)
            resetPicker(pickerDisplayedCharacters)
            galgjeEngine = GalgjeEngine(WithWord: word!, WithMaximumNumberOfAttempts: maximumNumberOfAttempts)
            galgjeEngine.attachDelegate(self)
            isLetterSelectionEnabled(true)
        } else {
            showAlert("WRONG!", validationResult.error!)
        }
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true)
    }
    
    private func validateSelectedWord(_ word: String?) -> (isValid: Bool, error: String?) {
        
        guard let unwrappedWord = word else {
            return ( false, "woord is leeg")
        }
        
        if unwrappedWord.isEmpty {
            return ( false, "woord is leeg" )
        }
        
        if unwrappedWord.count > 6 {
            return ( false, "woord moet minstens 6 karakters lang zijn" )
        }
        
        if !unwrappedWord.containsOnlyLetters() {
            return ( false, "woord moet enkel letters bevatten")
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
    
    private func resetPicker(_ picker: UIPickerView) {
        for i in 0...picker.numberOfComponents-1 {
            picker.selectRow(0, inComponent: i, animated: true)
        }
    }
    
    private func updateCorrectLettersHistory() {
        var newLine = ""
        
        newLine.append("\n")
        
        correctLetters.forEach({character in
            newLine.append(character)
            newLine.append(" ")
        })
        newLine.removeLast()
        
    
        textBoxCorrectLetterHistory.text?.append(newLine)
        
        let stringLength:Int = self.textBoxCorrectLetterHistory.text.count
        self.textBoxCorrectLetterHistory.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
}
