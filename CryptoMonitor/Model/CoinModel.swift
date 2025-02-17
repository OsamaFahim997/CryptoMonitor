//
//  CoinModel.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 3/2/25.
//

import Foundation

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    var currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case currentHoldings
    }
    
    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
    func copyWith(
            id: String? = nil,
            symbol: String? = nil,
            name: String? = nil,
            image: String? = nil,
            currentPrice: Double? = nil,
            marketCap: Double? = nil,
            marketCapRank: Double? = nil,
            fullyDilutedValuation: Double? = nil,
            totalVolume: Double? = nil,
            high24H: Double? = nil,
            low24H: Double? = nil,
            priceChange24H: Double? = nil,
            priceChangePercentage24H: Double? = nil,
            marketCapChange24H: Double? = nil,
            marketCapChangePercentage24H: Double? = nil,
            circulatingSupply: Double? = nil,
            totalSupply: Double? = nil,
            maxSupply: Double? = nil,
            ath: Double? = nil,
            athChangePercentage: Double? = nil,
            athDate: String? = nil,
            atl: Double? = nil,
            atlChangePercentage: Double? = nil,
            atlDate: String? = nil,
            lastUpdated: String? = nil,
            sparklineIn7D: SparklineIn7D? = nil,
            currentHoldings: Double? = nil
        ) -> CoinModel {
            return CoinModel(
                id: id ?? self.id,
                symbol: symbol ?? self.symbol,
                name: name ?? self.name,
                image: image ?? self.image,
                currentPrice: currentPrice ?? self.currentPrice,
                marketCap: marketCap ?? self.marketCap,
                marketCapRank: marketCapRank ?? self.marketCapRank,
                fullyDilutedValuation: fullyDilutedValuation ?? self.fullyDilutedValuation,
                totalVolume: totalVolume ?? self.totalVolume,
                high24H: high24H ?? self.high24H,
                low24H: low24H ?? self.low24H,
                priceChange24H: priceChange24H ?? self.priceChange24H,
                priceChangePercentage24H: priceChangePercentage24H ?? self.priceChangePercentage24H,
                marketCapChange24H: marketCapChange24H ?? self.marketCapChange24H,
                marketCapChangePercentage24H: marketCapChangePercentage24H ?? self.marketCapChangePercentage24H,
                circulatingSupply: circulatingSupply ?? self.circulatingSupply,
                totalSupply: totalSupply ?? self.totalSupply,
                maxSupply: maxSupply ?? self.maxSupply,
                ath: ath ?? self.ath,
                athChangePercentage: athChangePercentage ?? self.athChangePercentage,
                athDate: athDate ?? self.athDate,
                atl: atl ?? self.atl,
                atlChangePercentage: atlChangePercentage ?? self.atlChangePercentage,
                atlDate: atlDate ?? self.atlDate,
                lastUpdated: lastUpdated ?? self.lastUpdated,
                sparklineIn7D: sparklineIn7D ?? self.sparklineIn7D,
                currentHoldings: currentHoldings ?? self.currentHoldings
            )
        }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
