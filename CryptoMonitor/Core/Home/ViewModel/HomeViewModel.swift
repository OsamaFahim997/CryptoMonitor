//
//  HomeViewModel.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 4/2/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var portfolioCoins: [CoinModel] = []
    @Published var allCoins: [CoinModel] = []
    let dataService: CoinService
    var cancellables = Set<AnyCancellable>()
    
    init(coinService: CoinService = CoinService(allCoins: [])) {
        self.dataService = coinService
        addSubscribers()
    }
    
    func addSubscribers() {
        self.dataService.$allCoins
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }
    
    
}
