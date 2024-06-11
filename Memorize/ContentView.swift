import SwiftUI

struct ContentView: View {
    // or [String]
    let emojis: Array<String> = ["👻", "🧑‍🚒", "📡", "🧪"];
    
    var body: some View {
        HStack {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(isFaceUp: true, content: emojis[index])
            }
        }.foregroundColor(.orange)
            .padding()
    }
}

struct CardView: View {
    @State var isFaceUp = false;
    let content: String;
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12);
            
            if (isFaceUp) {
                base.fill(.white)
                base.strokeBorder(lineWidth: 4.0)
                Text(content)
                    .font(.largeTitle)
            } else {
                base.fill()
            }
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}


#Preview {
    ContentView()
}
