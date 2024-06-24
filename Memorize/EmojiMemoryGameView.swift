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
                .foregroundColor(viewModel.color)
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
    }
}

// a new ViewModel is created everytime this is executed,
// which is a bad practice, only to be used here
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
