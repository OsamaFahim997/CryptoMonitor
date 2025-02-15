//
//  CoinImageService.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import Foundation
import UIKit
import Combine

final class CoinImageService {
    
    @Published var image : UIImage?
    private let networkManager: NetworkManager
    private var imageCancellable: AnyCancellable?
    
    init(networkManager: NetworkManager = NetworkManager(), image: UIImage? = nil, url: String) {
        self.networkManager = networkManager
        self.image = image
        getImage(from: url)
    }
    
    func getImage(from url: String) {
        
        guard let url = URL(string: url) else { return }
        
        imageCancellable = networkManager.fetchDataFromServer(url: url)
            .tryMap ({ data -> UIImage? in
                if let image = UIImage(data: data) {
                    return image
                }
                return nil
            })
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] (responseImage) in
                self?.image = responseImage
                self?.imageCancellable?.cancel()
            })
    }
    
}
