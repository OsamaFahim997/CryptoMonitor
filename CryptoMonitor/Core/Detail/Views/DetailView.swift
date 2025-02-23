//
//  DetailView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 17/2/25.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    @State private var showDescription: Bool = false
    
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
                    
                    descriptionSection
                    overviewGrid
                    additionalDetailLabl
                    
                    Divider()
                    additionalDetailGrid
                    websiteSection
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
    
    private var descriptionSection: some View {
        ZStack {
            if let description = vm.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showDescription ? nil : 2)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showDescription.toggle()
                        }
                    }, label: {
                        Text(showDescription ? "Less" : "Read more...")
                            .foregroundColor(.blue)
                            .font(.caption)
                    })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 5)
            }
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
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let link = vm.websiteURL, let url = URL(string: link) {
                Link("Website", destination: url)
            }
            if let link = vm.redditURL, let url = URL(string: link) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
