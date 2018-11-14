import Foundation

protocol GalgjeEngineDelegate: NSObjectProtocol {
    func onGameWon()
    func onGameLost()
}

class GalgjeEngine {
    
    private weak var delegate: GalgjeEngineDelegate?
    
    private var _currentAttemptedLetters: [String]
    private(set) var currentCorrectLetters: [String] = ["_", "_", "_", "_"]
    private(set) var maximumAttempts: Int
    private(set) var currentWrongAttempts: Int
    private(set) var word: String
    
    var currentAttemptedLetters: [String] {
        get {
            return _currentAttemptedLetters
        }
        set (value) {
            _currentAttemptedLetters = value
        }
    }
    
    convenience init () {
        self.init(WithWord: String(), WithMaximumNumberOfAttempts: Int())
    }
    
    init(WithWord word: String, WithMaximumNumberOfAttempts maximumAttempts: Int) {
        self.word = word.uppercased()
        self.maximumAttempts = maximumAttempts
        _currentAttemptedLetters = [String]()
        currentWrongAttempts = 0
    }
    
    func attachDelegate(_ delegate: GalgjeEngineDelegate) {
        self.delegate = delegate
    }
    
    func detachDelegate() {
        delegate = nil
    }
    
    func resetEngine() {
        currentWrongAttempts = 0
    }
    
    func attempt(Letter letter: Character) -> (isInWord: Bool, atPositions: [Int]) {
        
        currentAttemptedLetters.append(String(letter))
        
        var isCharacterFound: Bool = false
        var positionsOfFoundCharacters: [Int] = [Int]()
        
        var currentPosition: Int = 0
        
        word.forEach({ character in
            if character == letter {
                isCharacterFound = true
                positionsOfFoundCharacters.append(currentPosition)
            }
            currentPosition += 1
        })
        
        if !isCharacterFound {
            currentWrongAttempts += 1
            if currentWrongAttempts == maximumAttempts {
                delegate?.onGameLost()
            }
        } else {
            
        }
        
        return ( isCharacterFound, positionsOfFoundCharacters )
    }
}
