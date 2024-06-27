//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Gustavo Fior on 24/06/24.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if number != 0  {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .offset(x: 0.0, y: offset)
                .foregroundStyle(number < 0 ? .red : .green)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 1.5, x: 1, y: 1)
                .opacity(offset != 0 ? 0 : 1)
                .onAppear {
                    withAnimation(.easeIn(duration: 1)) {
                        offset = number < 0 ? 100 : -100
                    }
                }
            // this is so that when we tap a card for the second time,
            // we get the animation of the flying points again
                .onDisappear{
                    offset = 0
                }
        }
    }
}

#Preview {
    FlyingNumber(number: 2)
}
