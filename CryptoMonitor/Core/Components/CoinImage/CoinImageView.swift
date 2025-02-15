//
//  CoinImageView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import SwiftUI
import Combine

struct CoinImageView: View {
    
    @StateObject var vm : CoinImageViewModel
    
    init(url: String) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CoinImageView(url: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
        .padding()
        .previewLayout(.sizeThatFits)
}
