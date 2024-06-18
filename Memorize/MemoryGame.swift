import Foundation

struct MemoryGame<CardContent> {
    // only setting is private, read isn't
    private(set) var cards: Array<Card>
    
    init (numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [];
        
        // creating the cards (foreach) | max is to find the max between the elements
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex);
            
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func chooseCard(_ card: Card) {
        
    }
    
    // mutating because this modify the model (MemoryGame)
    mutating func shuffle() {
        cards.shuffle();
        
        print(cards);
    }
    
    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
    }
}
