import SwiftUI

struct ContentView: View {
    // or [String]
    let emojis: Array<String> = ["👻", "🧑‍🚒", "📡", "🧪", "👻", "🧑‍🚒", "📡", "🧪"];
    
    var body: some View {
        ScrollView {
            cards
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(isFaceUp: true, content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
            
        }
        .foregroundColor(.orange)
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
