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
    @Published var searchText: String = ""
    
    let dataService: CoinService
    var cancellables = Set<AnyCancellable>()
    
    init(coinService: CoinService = CoinService(allCoins: [])) {
        self.dataService = coinService
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // Since we are using combineLatest with search text
        // doesn't need for seperate subscriber for allCoins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(dataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] updatedCoins in
                self?.allCoins = updatedCoins
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
    
    
}
