import Foundation
import CoreData

// MARK: - BitcoinRateStore Protocol
protocol BitcoinRateStore: AnyObject {
    func saveRate(_ rate: Double) async throws
    func getCurrentRate() throws -> Double?
}

// MARK: - BitcoinRateStore Implementation
final class BitcoinRateStoreImpl: BitcoinRateStore {
    private let database: CoreDataStack
    
    init(database: CoreDataStack) {
        self.database = database
    }
    
    func saveRate(_ rate: Double) async throws {
        let context = database.backgroundContext
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<CDBitcoinRate> = CDBitcoinRate.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            if let existingRate = try context.fetch(fetchRequest).first {
                existingRate.rate = rate
            } else {
                let cdBitcoinRate = CDBitcoinRate(context: context)
                cdBitcoinRate.rate = rate
            }
            
            try context.save()
        }
    }

    func getCurrentRate() throws -> Double? {
        let context = database.viewContext
        let request: NSFetchRequest<CDBitcoinRate> = CDBitcoinRate.fetchRequest()
        
        let result = try context.fetch(request)
        return result.first?.rate
    }
}
