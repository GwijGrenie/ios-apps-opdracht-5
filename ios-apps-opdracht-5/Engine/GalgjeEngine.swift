import Foundation

protocol GalgjeEngineDelegate: NSObjectProtocol {
    func onGameWon()
    func onGameLost()
}

class GalgjeEngine {
    
    private weak var delegate: GalgjeEngineDelegate?
    
    private(set) var currentAttemptedLetters: [Character]
    private(set) var currentCorrectLetters: [Character]
    private(set) var maximumAttempts: Int?
    private(set) var currentAttempts: Int
    private(set) var currentWrongAttempts: Int
    private(set) var word: String?
    
    convenience init() {
        self.init(nil)
    }
    
    init(_ delegate: GalgjeEngineDelegate?) {
        currentAttemptedLetters = [Character]()
        currentWrongAttempts = 0
        currentAttempts = 0
        
        currentCorrectLetters = [Character]()
        attachDelegate(delegate)
    }
    
    func attachDelegate(_ delegate: GalgjeEngineDelegate?) {
        self.delegate = delegate
    }
    
    func detachDelegate() {
        delegate = nil
    }
    
    func startNewGame(WithWord word: String, WithMaximumNumberOfAttempts maximumAttempts: Int) {
        self.word = word.uppercased()
        self.maximumAttempts = maximumAttempts
        
        resetEngine()
    }
    
    func resetEngine() {
        currentAttemptedLetters = [Character]()
        currentWrongAttempts = 0
        
        currentCorrectLetters = [Character]()
        
        if let word = self.word {
            for _ in 1...word.count {
                currentCorrectLetters.append("-")
            }
        }
    }
    
    func attempt(Letter letter: Character) -> (isInWord: Bool, atPositions: [Int]) {
        
        guard let word = self.word, let _ = self.maximumAttempts else {
            return (false, [Int]())
        }
        
        if !currentAttemptedLetters.contains(letter) {
            currentAttemptedLetters.append(letter)
        }
        
        currentAttempts += 1
        
        var isCharacterFound: Bool = false
        var positionsOfFoundCharacters: [Int] = [Int]()
        
        var currentPosition: Int = 0
        
        word.forEach({ character in
            if character == letter {
                isCharacterFound = true
                positionsOfFoundCharacters.append(currentPosition)
                currentCorrectLetters[currentPosition] = letter
            }
            currentPosition += 1
        })
        
        if !isCharacterFound {
            onCharacterNotFound()
        } else {
            onCharacterFound()
        }
        
        return ( isCharacterFound, positionsOfFoundCharacters )
    }
    
    private func onCharacterNotFound() {
        currentWrongAttempts += 1
        if currentWrongAttempts == maximumAttempts {
            delegate?.onGameLost()
        }
    }
    
    private func onCharacterFound() {
        if String(currentCorrectLetters) == word {
            delegate?.onGameWon()
        }
    }
}
