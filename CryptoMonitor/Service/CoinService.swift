//
//  CoinService.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import Foundation
import Combine

final class CoinService {
    
    @Published var allCoins: [CoinModel]
    private let networkManager: NetworkManager
    var coinCancellable: AnyCancellable?
    
    init(allCoins: [CoinModel] = [], networkManager: NetworkManager = NetworkManager()) {
        self.allCoins = allCoins
        self.networkManager = networkManager
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true") else { return }
        
        coinCancellable = networkManager.fetchDataFromServer(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkManager.handleCompletion,
                  receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.coinCancellable?.cancel()
            })
    }
    
    func fetchImage() {
        
    }
    
}
