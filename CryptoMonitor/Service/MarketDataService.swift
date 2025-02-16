//
//  MarketDataService.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    private let networkManager: NetworkManager
    private var marketDataCancellable: AnyCancellable?
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
        fetchGlobalData()
    }
    
    private func fetchGlobalData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataCancellable = networkManager.fetchDataFromServer(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkManager.handleCompletion,
                  receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataCancellable?.cancel()
            })
    }
}
