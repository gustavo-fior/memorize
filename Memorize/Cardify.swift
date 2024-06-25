//
//  Cardify.swift
//  Memorize
//
//  Created by Gustavo Fior on 23/06/24.
//

import SwiftUI

// modifier to make something look like a card
// implements Animatable so that we can animate opacity
struct Cardify: ViewModifier, Animatable {
    
    // init so that we can initialize this passing isFaceUp, not rotation
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180;
    }
    
    // computed var
    var isFaceUp : Bool {
        rotation < 90
    }
    
    // just an alias to animatableData
    var rotation: Double
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius);
            
            base.strokeBorder(lineWidth: Constants.lineWidth)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        // can rotate in any axis
        .rotation3DEffect(
            .degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
}

private struct Constants {
    static let cornerRadius: CGFloat = 24
    static let lineWidth: CGFloat = 2
}


// so that we can say .cardify instead of .modifier(Cardify))
extension View {
    func cardify (isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
