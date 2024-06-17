import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func chooseCard(card: Card) {
        
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
