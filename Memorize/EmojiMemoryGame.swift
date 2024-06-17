// ViewModel

import SwiftUI

class EmojiMemoryGame {
    
    init(model: MemoryGame<String>) {
        self.model = model
    };
    
    // terrible name, should be something like game
    var model: MemoryGame<String>
}
