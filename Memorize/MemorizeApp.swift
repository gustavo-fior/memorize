//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gustavo Fior on 05/06/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    // using the state in the root level for the ViewModel
    @StateObject var game = EmojiMemoryGame();
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
