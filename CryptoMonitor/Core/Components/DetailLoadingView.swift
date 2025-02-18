//
//  DetailLoadingView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 18/2/25.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

#Preview {
    DetailLoadingView()
}
