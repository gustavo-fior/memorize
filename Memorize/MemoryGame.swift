import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // only setting is private, read isn't
    private(set) var cards: Array<Card>
    private(set) var score = 0
    
    init (numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [];
        
        // creating the cards (foreach) | max is to find the max between the elements
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex);
            
            cards.append(Card(id: "\(pairIndex+1)a", content: content))
            cards.append(Card(id: "\(pairIndex+1)b",content: content))
        }
    }
    
    // does not need to be initialized, since its and optional (starts with = nil)
    var indexOfTheOnlyCardFacingUp: Int? {
        get { cards.indices.filter({index in cards[index].isFaceUp}).only }
        set { cards.indices.forEach({index in cards[index].isFaceUp = (newValue == index)}) }
    }
    
    mutating func chooseCard(_ card: Card) {
        
        // $0 means the first param in this function (which is the card to be compared)
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOnlyCardFacingUp {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true;
                        cards[potentialMatchIndex].isMatched = true;
                        
                        score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
                    } else {
                        if cards[chosenIndex].hasBeenSeen {
                            score -= 1
                        }
                        
                        if cards[potentialMatchIndex].hasBeenSeen {
                            score -= 1
                        }
                    }
                } else {
                    indexOfTheOnlyCardFacingUp = chosenIndex;
                }
                
                cards[chosenIndex].isFaceUp = true;
            }
        }
    }
    
    // mutating because this modify the model (MemoryGame)
    mutating func shuffle() {
        cards.shuffle();
        
        print(cards);
    }
    
    // if the equatable expression is not set, swift will compare all vars
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        // unique id that needs to be hashable
        var id: String
        
        // property observers (before set and after set), basically generating the value for another property (hasBeenSeen) from the change of another
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
                
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        var hasBeenSeen = false
        let content: CardContent
        
        // basically a ToString()
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "is up" : "is down") and \(isMatched ? "is matched" : "is not matched")";
        }
    }
}

// adding an extension to array

extension Array {
    var only: Element? {
        count == 1 ? first : nil;
    }
}
