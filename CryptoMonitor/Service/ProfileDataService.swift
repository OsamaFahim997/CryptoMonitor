//
//  ProfileDataService.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 17/2/25.
//

import Foundation
import CoreData

class ProfileDataService {
    
    var container: NSPersistentContainer
    let containerName: String = "PortfolioContainer"
    let entityName: String = "ProfileEntity"
    
    @Published var savedEntites: [ProfileEntity] = []
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        self.container.loadPersistentStores { _, error in
            if let error = error {
                print("Error in fetching data from PortfolioContainer with error: \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntites.first(where: { $0.id == coin.id }) {
            if amount > 0 {
                update(amount: amount, entity: entity)
            } else {
                delete(entity: entity)
            }
        } else {
            addCoin(coin: coin, amount: amount)
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<ProfileEntity>(entityName: entityName)
        do {
            savedEntites = try container.viewContext.fetch(request)
        } catch {
            print("error in fetching profileEntity with error: \(error.localizedDescription)")
        }
    }
    
    private func addCoin(coin: CoinModel, amount: Double) {
        let entity = ProfileEntity(context: container.viewContext)
        entity.id = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(amount: Double, entity: ProfileEntity) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: ProfileEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error in saving data of profileEntity with error: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
