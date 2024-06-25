import SwiftUI

struct EmojiMemoryGameView: View {
    // type alias
    typealias Card = MemoryGame<String>.Card;
    
    // @ObservedObject so that the view listens to the changes here
    // better name would be memoryGame
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            cards
                .foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                shuffle
            }
            .font(.title3)
        }
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
        // implicit animation to don't animate
            .animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            
            // animating explicitily
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.chooseCard(card)
                    }
                }
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        0
    }
}

// a new ViewModel is created everytime this is executed,
// which is a bad practice, only to be used here
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
