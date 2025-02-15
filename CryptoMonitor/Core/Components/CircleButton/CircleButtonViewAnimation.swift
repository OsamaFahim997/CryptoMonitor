//
//  CircleButtonViewAnimation.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 2/2/25.
//

import SwiftUI

struct CircleButtonViewAnimation: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeInOut(duration: 1.0) : .none)
    }
}

#Preview {
    CircleButtonViewAnimation(animate: .constant(false))
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
