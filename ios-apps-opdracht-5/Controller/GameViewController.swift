import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var pickerDisplayedCharacters: UIPickerView!
    @IBOutlet weak var pickerUserSelectedLetter: UIPickerView!
    @IBOutlet weak var buttonPlayLetter: UIButton!
    @IBOutlet weak var imageGallows: UIImageView!
    @IBOutlet weak var textBoxCorrectLetterHistory: UITextView!
    
    private let maximumNumberOfAttempts: Int = 11
    
    private var galgjeEngine: GalgjeEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGallows.isHidden = true
        
        galgjeEngine = GalgjeEngine(self)
    }
    
    @IBAction func onTapStartGame(_ sender: UITapGestureRecognizer) {
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
    
    @IBAction func onTouchUpInsideButtonPlayLetter(_ sender: UIButton) {
        
        let currentSelectedCharacter = PickerSelectableCharactersDataSourceDelegate.selectableCharacters[pickerUserSelectedLetter.selectedRow(inComponent: 0)]
        
        if galgjeEngine.currentAttemptedLetters.contains(Character(currentSelectedCharacter)) {
            return
        }
        
        let resultOfAttempt = galgjeEngine.attempt(Letter: Character(currentSelectedCharacter))
        
        if resultOfAttempt.isInWord {
            resultOfAttempt.atPositions.forEach({position in
                
                let indexOfCharacter = PickerDisplayedCharactersDataSourceDelegate.displayedCharacters.firstIndex(of: currentSelectedCharacter)!
                pickerDisplayedCharacters.selectRow(indexOfCharacter, inComponent: position, animated: true)
            })
            updateCorrectLettersHistory()
        } else {
            let currentWrongAttempts = galgjeEngine.currentWrongAttempts
            imageGallows.isHidden = false
            imageGallows.image = UIImage(named: "galgje" + String(currentWrongAttempts))
        }
    }
}

extension GameViewController: GalgjeEngineDelegate {
    
    func onGameWon() {
        
        let alertHighscore: UIAlertController = UIAlertController(title: "Gewonnen", message: "Geef uw naam...", preferredStyle: UIAlertController.Style.alert)
        alertHighscore.addAction(UIAlertAction(title: "Annuleer", style: UIAlertAction.Style.cancel, handler: nil))
        alertHighscore.addTextField(configurationHandler: { textField in
            textField.placeholder = "Naam..."
        })
        alertHighscore.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.onNameGiven(alertHighscore)
        }))
        
        present(alertHighscore, animated: true)
        
        isLetterSelectionEnabled(false)
    }
    
    func onGameLost() {
        showAlert("Verloren", "Jammer!")
        isLetterSelectionEnabled(false)
    }
}

extension GameViewController {
    
    private func onSelectedWord(_ alert: UIAlertController) {
        let word = alert.textFields?.first?.text
        
        let validationResult = self.validateSelectedWord(word)
        
        if validationResult.isValid {
            resetPicker(pickerUserSelectedLetter)
            resetPicker(pickerDisplayedCharacters)
            resetCorrectLetterHistory()
            
            galgjeEngine.startNewGame(WithWord: word!, WithMaximumNumberOfAttempts: maximumNumberOfAttempts)
            
            isLetterSelectionEnabled(true)
        } else {
            showAlert("Verkeerde invoer", validationResult.error!)
        }
    }
    
    private func onNameGiven(_ alert: UIAlertController) {
        guard let name = alert.textFields?.first?.text else {
            return
        }
        
        let defaults = UserDefaults.standard
        
        if defaults.dictionary(forKey: "highScores") == nil {
            defaults.set([String: Int](), forKey: "highScores")
        }
        
        var highScores = defaults.dictionary(forKey: "highScores")
        highScores![name] = self.galgjeEngine.currentAttempts
        
        defaults.set(highScores, forKey: "highScores")
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true)
    }
    
    private func validateSelectedWord(_ word: String?) -> (isValid: Bool, error: String?) {
        guard let unwrappedWord = word else {
            return ( false, "Woord is leeg")
        }
        
        if unwrappedWord.isEmpty {
            return ( false, "Woord is leeg" )
        }
        
        if unwrappedWord.count != 6 {
            return ( false, "Woord moet minstens 6 karakters lang zijn" )
        }
        
        if !unwrappedWord.containsOnlyLetters() {
            return ( false, "Woord moet enkel letters bevatten")
        }
        
        return ( true, nil )
    }
}

extension GameViewController {
    
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
    
    private func resetCorrectLetterHistory() {
        textBoxCorrectLetterHistory.text = "- - - - - -"
    }
    
    private func updateCorrectLettersHistory() {
        var newLine = ""
        
        newLine.append("\n")
        
        galgjeEngine.currentCorrectLetters.forEach({character in
            newLine.append(character)
            newLine.append(" ")
        })
        newLine.removeLast()
        
    
        textBoxCorrectLetterHistory.text?.append(newLine)
        
        let stringLength:Int = self.textBoxCorrectLetterHistory.text.count
        self.textBoxCorrectLetterHistory.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
}
