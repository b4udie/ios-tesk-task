//
//  TransactionStore.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import Combine
import CoreData

protocol TransactionStore: AnyObject {
    func insert(_ transaction: Transaction) async throws
    func fetchTransactions(limit: Int, offset: Int) throws -> [Transaction]
    func fetchTotalCount() throws -> Int
    func getCurrentBalance() throws -> Double
    func updateBalance(_ newBalance: Double) throws
}

final class TransactionStoreImpl: TransactionStore {
    private let database: CoreDataStack
    private let subject = CurrentValueSubject<[TransactionGroup], Never>([])
    private var cancellables = Set<AnyCancellable>()

    init(database: CoreDataStack) {
        self.database = database
    }
    
    func insert(_ transaction: Transaction) async throws {
        let context = database.backgroundContext
        try await context.perform {
            let fetch = CDTransaction.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
            let object = try context.fetch(fetch).first ?? CDTransaction(context: context)
            object.update(from: transaction)
            try context.save()
        }
    }

    func fetchTransactions(limit: Int, offset: Int) throws -> [Transaction] {
        let request = CDTransaction.fetchRequest()
        request.fetchLimit = limit
        request.fetchOffset = offset
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        let rows = try database.viewContext.fetch(request)
        return rows.map { $0.toDomain() }
    }

    func fetchTotalCount() throws -> Int {
        let request = CDTransaction.fetchRequest()
        request.resultType = .countResultType
        return try database.viewContext.count(for: request)
    }

    func getCurrentBalance() throws -> Double {
        let request = CDBalance.fetchRequest()
        let balance = try database.viewContext.fetch(request).first
        return balance?.balance ?? 0.0
    }

    func updateBalance(_ newBalance: Double) throws {
        let request = CDBalance.fetchRequest()
        let balance = try database.viewContext.fetch(request).first ?? CDBalance(context: database.viewContext)
        balance.balance = newBalance
        try database.viewContext.save()
    }
}
