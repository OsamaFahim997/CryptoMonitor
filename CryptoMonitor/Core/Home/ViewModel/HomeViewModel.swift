//
//  HomeViewModel.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 4/2/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    let coinService: CoinService
    let marketDataService: MarketDataService
    var cancellables = Set<AnyCancellable>()
    
    init(coinService: CoinService = CoinService(allCoins: []), marketDataService: MarketDataService = MarketDataService()) {
        self.coinService = coinService
        self.marketDataService = marketDataService
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // Since we are using combineLatest with search text
        // doesn't need for seperate subscriber for allCoins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(coinService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] updatedCoins in
                self?.allCoins = updatedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .receive(on: DispatchQueue.main)
            .map(mapMarketServiceData)
            .sink { [weak self] statsModel in
                self?.statistics = statsModel
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter ({
            $0.id.contains((lowercasedText)) ||
            $0.name.contains((lowercasedText)) ||
            $0.symbol.contains((lowercasedText))
        })
    }
    
    private func mapMarketServiceData(marketData: MarketDataModel?) -> [StatisticModel] {
        guard let data = marketData else { return [] }
        
        var stats = [StatisticModel]()
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDomincance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio", value: "0", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap, volume, btcDomincance, portfolio
        ])
        return stats
    }
}
