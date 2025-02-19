//
//  DetailView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 17/2/25.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: CoinModel) {
        self._vm = .init(wrappedValue: .init(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical, 5)
                
                VStack(spacing: 15) {
                    overiewLabel
                    Divider()
                    overviewGrid
                    
                    additionalDetailLabl
                    Divider()
                    additionalDetailGrid
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name.uppercased())
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                navigationTrailingItem
            }
        })
    }
}

#Preview {
    NavigationView(content: {
        DetailView(coin: DeveloperPreview.instance.coin)
    })
}

extension DetailView {
    
    private var navigationTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overiewLabel: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  content: {
            ForEach(vm.overviewStatistics) { model in
                StatisticView(stat: model)
            }
        })
    }
    
    private var additionalDetailLabl: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalDetailGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: 30,
                  content: {
            ForEach(vm.additionalStatistics) { model in
                StatisticView(stat: model)
            }
        })
    }
}
