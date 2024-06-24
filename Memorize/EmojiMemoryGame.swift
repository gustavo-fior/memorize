// ViewModel

import SwiftUI

// this is an example of full separation: only this VM can access the Model
class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card;
    
    // static so that this is global, but only in this class (variables are not initialized in order)
    private static let emojis = ["👻", "🧑‍🚒", "📡", "🧪", "🤘🏻", "🥳", "5️⃣", "💡", "💰"];
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 2) { pairIndex in
            if (emojis.indices.contains(pairIndex)) {
                return emojis[pairIndex];
            }
            
            return "😬"
        }
    }
    
    // @Published so that when this var changes, the view listens
    // terrible name, should be something like game
    @Published private var model = createMemoryGame();
    
    // -------------
    // what the view can use:
    
    var cards : Array<Card> {
        model.cards;
    }
    
    var color: Color {
        .cyan;
    }
    
    // MARK: - Intents:
    
    func chooseCard(_ card: Card) {
        model.chooseCard(card);
    }
    
    func shuffle() {
        model.shuffle();
        objectWillChange.send()
    }
}
