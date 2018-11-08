import Foundation

protocol GalgjeEngineDelegate: NSObjectProtocol {
    func onGameWon()
    func onGameLost()
}

class GalgjeEngine {
    
    private weak var delegate: GalgjeEngineDelegate?
    
    private var _word: String
    private var _maximumAttempts: Int
    private var _currentAttemptedLetters: [String]
    private(set) var currentWrongAttempts: Int
    
    var word: String {
        get {
            return _word
        }
        set (value) {
            _word = value.uppercased()
        }
    }
    
    var maximumAttempts: Int {
        get {
            return _maximumAttempts
        }
        set (value) {
            _maximumAttempts = value
        }
    }
    
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
        _word = word.uppercased()
        _maximumAttempts = maximumAttempts
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
    
    func attempt(Letter letter: Character) -> (IsInWord: Bool, AtPositions: [Int]) {
        
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
        }
        
        return ( isCharacterFound, positionsOfFoundCharacters )
    }
}
