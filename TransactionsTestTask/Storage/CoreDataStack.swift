//
//  CoreDataStack.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 23.08.2025.
//

import CoreData
import Combine

final class CoreDataStack {
    private let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return ctx
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TransactionsTestTask")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        if let d = container.persistentStoreDescriptions.first {
            d.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            d.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }
        container.loadPersistentStores { _, error in
            if let error = error { 
                fatalError("Core Data load error: \(error)") 
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
