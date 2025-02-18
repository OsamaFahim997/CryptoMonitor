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
    
    @StateObject private var vm: CoinDetailViewModel
    
    init(coin: CoinModel) {
        self._vm = .init(wrappedValue: .init(coin: coin))
    }
    
    var body: some View {
        Text("Osama")
    }
}

#Preview {
    DetailView(coin: DeveloperPreview.instance.coin)
}
