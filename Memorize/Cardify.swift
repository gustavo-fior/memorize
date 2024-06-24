//
//  Cardify.swift
//  Memorize
//
//  Created by Gustavo Fior on 23/06/24.
//

import SwiftUI

// modifier to make something look like a card
struct Cardify: ViewModifier {
    let isFaceUp : Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius);
            
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
    }
}

private struct Constants {
    static let cornerRadius: CGFloat = 12
    static let lineWidth: CGFloat = 2
}


// so that we can say .cardify instead of .modifier(Cardify))
extension View {
    func cardify (isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
