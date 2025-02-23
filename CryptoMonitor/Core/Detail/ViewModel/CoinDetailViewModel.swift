//
//  CoinDetailViewModel.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 18/2/25.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    @Published var coinDetail: CoinDetailViewModel? = nil
    @Published var coin: CoinModel
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private var coinDetailService: CoinDetailService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailService(coin: coin)
        addSubscribers()
    }
    
    func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapStatisticsData)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.0
                self?.additionalStatistics = returnedArrays.1
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetail
            .sink { [weak self] coinDetil in
                self?.coinDescription = coinDetil?.readableDescription
                self?.websiteURL = coinDetil?.links?.homepage?.first
                self?.redditURL = coinDetil?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    func mapStatisticsData(coinDetailModel: CoinDetailModel?, coin: CoinModel) -> ([StatisticModel], [StatisticModel]) {
        let overviewStatistics = self.mapOverviewStatistics(coin)
        let additionalStatistics = self.mapAdditionalStatistics(coinDetailModel, coin)
        return (overviewStatistics, additionalStatistics)
    }
    
    private func mapOverviewStatistics(_ coin: CoinModel) -> [StatisticModel] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketeCapPercentageChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitilization", value: marketCap, percentageChange: marketeCapPercentageChange)
        
        let rankStat = StatisticModel(title: "Rank", value: String(coin.rank))
        
        let volume = "$" + String(coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func mapAdditionalStatistics(_ coinDetailModel: CoinDetailModel?, _ coin: CoinModel) -> [StatisticModel] {
        let high24H = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high24H)
        
        let low24H = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low24H)
        
        let priceChange24H = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let priceChange24H2 = coin.priceChange24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange24H, percentageChange: priceChange24H2)
        
        let marketChange24H = "$" + (coin.marketCapChange24H?.asCurrencyWith6Decimals() ?? "")
        let marketCapPercentageChange = coin.marketCapChangePercentage24H
        let marketCapPercentageStat = StatisticModel(title: "24h Market Change", value: marketChange24H, percentageChange: marketCapPercentageChange)
        
        let blockTime = (coinDetailModel?.blockTimeInMinutes) ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? ""
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapPercentageStat, blockTimeStat, hashingStat]
    }
    
}
