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
    private var coinDetailService: CoinDetailService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailService(coin: coin)
        addSubscribers()
    }
    
    func addSubscribers() {
        coinDetailService.$coinDetail
            .sink { detail in
                print("Coin detail received \(detail)")
            }
            .store(in: &cancellables)
    }
    
}
