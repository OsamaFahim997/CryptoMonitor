//
//  NetworkManager.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 15/2/25.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badResponse(url: URL)
        case unknownError
        
        var localisedError: String {
            switch self {
            case .badResponse(let url):
                return "Bad response from server of url: \(url.absoluteString)"
            case .unknownError:
                return "Unknown error occured"
            }
        }
    }
    
    func getRequest() {
        
    }
    
    func fetchDataFromServer(url: URL) -> AnyPublisher<Data, any Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, res) -> Data in
                guard let res = res as? HTTPURLResponse, res.statusCode >= 200 && res.statusCode < 300 else {
                    throw NetworkError.badResponse(url: url)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func handleCompletion(completion: (Subscribers.Completion<Error>)) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Error occured while fetching coin data with \(error.localizedDescription)")
        }
    }
    
    
    
}
