import SwiftUI

struct EmojiMemoryGameView: View {
    // type alias
    typealias Card = MemoryGame<String>.Card;
    
    // @ObservedObject so that the view listens to the changes here
    // better name would be memoryGame
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealInterval : TimeInterval = 0.15
    private let dealAnimation : Animation = .easeInOut(duration: 0.5)
    private let deckWidth: CGFloat = 50
    
    var body: some View {
        VStack {
            cards.foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
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
            if (isDealt(card)) {
                CardView(card)
                // so that the cards in the deck go to their place
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))                    
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0 )
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    // @State only when it's temporary state | only UI
    // state var because this is UI only, so we do not use @ObservedObject
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNameSpace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                // so that the cards in the deck go to their place
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                // this keeps the matchedGeometryEffect, but removes other transitions
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        // view modifier to
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        // deal the cards
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.chooseCard(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    // the type of this var is a tuple (Int, Card.ID -> this is the property from Identifiable)
    // you can have named and unnamed variables
    private func scoreChange(causedBy card: Card) -> Int {
        // opening the tuple
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

// a new ViewModel is created everytime this is executed,
// which is a bad practice, only to be used here
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
