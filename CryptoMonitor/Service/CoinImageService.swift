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
    
    @Published var image : UIImage? = nil
    
    private var coinModel: CoinModel
    private let networkManager: NetworkManager
    private var imageCancellable: AnyCancellable?
    private var localImageManager = LocalFileManager.instance
    private var folderName = "coin_images"
    private var imageName: String
    
    init(networkManager: NetworkManager = NetworkManager(), coinModel: CoinModel) {
        self.networkManager = networkManager
        self.coinModel = coinModel
        self.imageName = coinModel.id
        getImage()
    }
    
    func getImage() {
        if let image = localImageManager.getImage(imageName: imageName, folderName: folderName) {
            print("Find saved image")
            self.image = image
        } else {
            self.downloadImage(from: coinModel.image)
            print("Downloading images ")
        }
    }
    
    func downloadImage(from url: String) {
        
        guard let url = URL(string: url) else { return }
        
        imageCancellable = networkManager.fetchDataFromServer(url: url)
            .tryMap ({ data -> UIImage? in
                if let image = UIImage(data: data) { return image }
                return nil
            })
            .sink(receiveCompletion: networkManager.handleCompletion, receiveValue: { [weak self] (responseImage) in
                guard let self = self, let responseImage = responseImage else { return }
                self.image = responseImage
                self.imageCancellable?.cancel()
                self.localImageManager.saveImage(image: responseImage, imageName: imageName, folderName: folderName)
            })
    }
    
}
