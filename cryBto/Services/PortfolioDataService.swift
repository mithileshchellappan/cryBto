//
//  PortfolioDataService.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 29/10/23.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription + " Error loading core data")
            }
        }
        self.getPortfolio()
    }
    
    //MARK: PUBLIC
    
    func updatePortfolio(coin: Coin,amount: Double){
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else {
                delete(entity: entity)
            }
        }else{
            print("added")
            add(coin: coin, amount: amount)
        }
        
    }
    
    //MARK: PRIVATE
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entites \(error)")
        }
    }
    
    private func add(coin: Coin,amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        sync()
    }
    
    private func update(entity: PortfolioEntity,amount:Double){
        entity.amount = amount
        sync()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        sync()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to core data \(error)")
        }
    }
    
    private func sync() {
        save()
        getPortfolio()
    }
}
