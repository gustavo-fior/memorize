import SwiftUI

struct ContentView: View {
    // or [String]
    let emojis: Array<String> = ["👻", "🧑‍🚒", "📡", "🧪", "👻", "🧑‍🚒", "📡", "🧪"];
    @State var cardCount: Int = 4;
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCounter
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(isFaceUp: true, content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
            
        }
        .foregroundColor(.orange)
    }
    
    var cardCounter: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }.imageScale(.large)
            .font(.largeTitle)
    }
    
    func cardCounterAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset;
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
    
    var cardRemover: some View {
        cardCounterAdjuster(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
    
    var cardAdder: some View {
        cardCounterAdjuster(by: 1, symbol: "rectangle.stack.fill.badge.plus")
    }
}

struct CardView: View {
    @State var isFaceUp = false;
    let content: String;
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12);
            
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 4.0)
                Text(content)
                    .font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill().opacity(isFaceUp ? 0 : 1)
            
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}


#Preview {
    ContentView()
}
