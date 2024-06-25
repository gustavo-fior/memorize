import SwiftUI

struct CardView: View {
    
    // type alias
    typealias Card = MemoryGame<String>.Card;
    
    let card: Card;
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(270))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.inset)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    // implicit animation
                    .animation(.spin(duration: 1), value: card.isMatched)
            )
            .padding(Constants.Pie.inset)
            .cardify(isFaceUp: card.isFaceUp)
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0);
    }
    
    // to get away of magic numbers -> create a private struct with the values inside it
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = smallest/largest
        }
        struct Pie {
            static let opacity: CGFloat = 0.4
            static let inset: CGFloat = 5
        }
    }
}

// extension for a animation "preset" that spins
extension Animation {
    static func spin (duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    // type alias
    typealias Card = MemoryGame<String>.Card;
    
    return VStack {
        HStack{
            CardView(Card(id: "test", isFaceUp: true, isMatched: true, content: "xthis is adsabfas fsa s fa bf asfb saj fjf jsba fbjas fs"))
            CardView(Card(id: "test", content: "x"))
        }
        HStack{
            CardView(Card(id: "test", content: "x"))
            CardView(Card(id: "test", content: "x"))
        }
    }.padding()
        .foregroundColor(.green)
}
