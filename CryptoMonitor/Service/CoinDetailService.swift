//
//  CoinDetailService.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 18/2/25.
//

import Foundation
import Combine

final class CoinDetailService {
    
    @Published var coinDetail: CoinDetailModel? = nil
    private let coin: CoinModel
    private let networkManager: NetworkManager
    private var coinDetailCancellable: AnyCancellable?
    
    init(coin: CoinModel, networkManager: NetworkManager = NetworkManager()) {
        self.coin = coin
        self.networkManager = networkManager
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailCancellable = networkManager.fetchDataFromServer(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: networkManager.handleCompletion,
                  receiveValue: { [weak self] coinDetail in
                self?.coinDetail = coinDetail
                self?.coinDetailCancellable?.cancel()
            })
    }
}
