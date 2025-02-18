//
//  DetailView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 17/2/25.
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

struct DetailView: View {
    
    var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("Initializing detail view")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
