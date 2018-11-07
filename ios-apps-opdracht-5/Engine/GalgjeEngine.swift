import Foundation

class GalgjeEngine {
    
    private var _word: String
    private var _maximumAttempts: Int
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
    
    convenience init () {
        self.init(WithWord: String(), WithMaximumNumberOfAttempts: Int())
    }
    
    init(WithWord word: String, WithMaximumNumberOfAttempts maximumAttempts: Int) {
        _word = word.uppercased()
        _maximumAttempts = maximumAttempts
        currentWrongAttempts = 0
    }
    
    func resetEngine() {
        currentWrongAttempts = 0
    }
    
    func attempt(Letter letter: Character) -> (IsInWord: Bool, AtPositions: [Int]) {
        
        var isCharacterFound: Bool = false
        var positionsOfFoundCharacters: [Int] = [Int]()
        
        var currentPosition: Int = 0
        
        word.forEach({ character in
            print(character)
            if character == letter {
                isCharacterFound = true
                positionsOfFoundCharacters.append(currentPosition)
                currentPosition += 1
            }
        })
        
        if !isCharacterFound {
            currentWrongAttempts += 1
        }
        
        return ( isCharacterFound, positionsOfFoundCharacters )
    }
}
