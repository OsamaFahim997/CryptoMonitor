//
//  CoinRowView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 4/2/25.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack {
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
        }
        
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(width: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.callout)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
                Text("\(coin.currentHoldingsValue.asCurrencyWith6Decimals())")
                    .bold()
                    .foregroundColor(.theme.accent)
                
                Text(coin.currentHoldings?.convertPercentageToTwoDecimals() ?? "")
                    .font(.subheadline)
                    .foregroundColor(.theme.accent)
            
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .bold()
                .foregroundColor(.theme.accent)
            Text(coin.priceChangePercentage24H?.convertPercentageToTwoDecimals() ?? "")
                .font(.callout)
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) > 0 ?
                    Color.green : Color.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
}
