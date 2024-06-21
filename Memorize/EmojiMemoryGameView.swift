import SwiftUI

struct EmojiMemoryGameView: View {
    // @ObservedObject so that the view listens to the changes here
    // better name would be memoryGame
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            cards
                .animation(.default, value: viewModel.cards )
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.chooseCard(card)
                }
        }
        .foregroundColor(.orange)
    }
}

struct CardView: View {
    
    let card: MemoryGame<String>.Card;
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12);
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2.0)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            
            base.fill().opacity(card.isFaceUp ? 0 : 1)
            
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0);
    }
}


// a new ViewModel is created everytime this is executed,
// which is a bad practice, only to be used here
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
