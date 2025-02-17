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
    let profileDataService: ProfileDataService
    var cancellables = Set<AnyCancellable>()
    
    init(coinService: CoinService = CoinService(allCoins: []), 
         marketDataService: MarketDataService = MarketDataService(),
         profileDataService: ProfileDataService = ProfileDataService()) {
        self.coinService = coinService
        self.marketDataService = marketDataService
        self.profileDataService = profileDataService
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
        
        $allCoins
            .combineLatest(profileDataService.$savedEntites)
            .map { (allCoin, entities) in
                var profileCoins = [CoinModel]()
                for coin in entities {
                    if let findCoin = allCoin.first(where: {$0.id == coin.id}) {
                        let updatedCoin = findCoin.copyWith(currentHoldings: coin.amount)
                        profileCoins.append(updatedCoin)
                    }
                }
                return profileCoins
            }
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)
    }
    
    func checkForCurrentHolding(of coin: CoinModel?) -> String {
        if let coin = coin,
           let findCoin = portfolioCoins.first(where: {$0.id == coin.id }),
           findCoin.currentHoldings != nil {
            return String(findCoin.currentHoldings ?? 0)
        }
        return ""
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        profileDataService.updatePortfolio(coin: coin, amount: amount)
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
