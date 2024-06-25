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
            if !cards[chosenIndex].isFaceUp || !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOnlyCardFacingUp {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true;
                        cards[potentialMatchIndex].isMatched = true;
                        
                        score += 2
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
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        
        var isMatched = false
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
