//
//  CoinImageViewModel.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import Foundation
import Combine
import UIKit

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    private let coinService: CoinImageService?
    private var cancellables = Set<AnyCancellable>()
    
    init(url: String) {
        self.coinService = CoinImageService(url: url)
        addSubscribers()
    }
    
    func addSubscribers() {
        coinService?.$image
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = true
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
            .store(in: &cancellables)
    }
    
}
