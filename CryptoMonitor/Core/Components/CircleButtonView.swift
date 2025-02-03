//
//  CircleButtonView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 2/2/25.
//

import SwiftUI

struct CircleButtonView: View {
    
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.headline)
            .foregroundColor(.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(.theme.background)
            )
            .shadow(color: .theme.accent.opacity(0.25), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding()
    }
}

#Preview {
    Group {
        CircleButtonView(icon: "plus")
            .previewLayout(.sizeThatFits)
        
        CircleButtonView(icon: "info")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
    
}
