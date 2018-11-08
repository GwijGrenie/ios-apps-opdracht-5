import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerDisplayedCharacters: UIPickerView!
    @IBOutlet weak var pickerUserSelectedLetter: UIPickerView!
    @IBOutlet weak var buttonPlayLetter: UIButton!
    @IBOutlet weak var imageGallows: UIImageView!
    
    private var alertStartGame: UIAlertController?
    
    private let maximumNumberOfAttempts = 11
    
    private var galgjeEngine: GalgjeEngine! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGallows.isHidden = true
        
        initStartGameAlert()
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
            })
        } else {
            let currentWrongAttempts = galgjeEngine.currentWrongAttempts
            imageGallows.isHidden = false
            imageGallows.image = UIImage(named: "galgje" + String(currentWrongAttempts))
        }
    }
}

extension ViewController: GalgjeEngineDelegate {
    func onGameWon() {
        
    }
    
    func onGameLost() {
        
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
