//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
/// There is an example of a _bad_ services relationship built on `onRateUpdate` callback
/// This kind of relationship must be refactored with a more convenient and reliable approach
///
/// It's ok to move the logging to model/viewModel/interactor/etc when you have 1-2 modules in your app
/// Imagine having rate updates in 20-50 diffent modules
/// Make this logic not depending on any module
enum ServicesAssembler {
    // MARK: - AnalyticsService
    
    static let analyticsService: PerformOnce<AnalyticsService> = {
        let service = AnalyticsServiceImpl()
        return { service }
    }()
    
    // MARK: - NetworkReachability
    
    static let networkReachability: PerformOnce<NetworkReachability> = {
        let service = NetworkReachabilityImpl()
        return { service }
    }()
    
    // MARK: - NetworkLayer

    static func bitcoinRateNetworkService(_ plugins: NetworkPlugin...) -> BitcoinRateNetworkService {
        let defaultPlugins = [LoggingPlugin()]
        let allPlugins = defaultPlugins + plugins
        let networkClient = URLSessionNetworkClient(plugins: allPlugins)
        return BitcoinRateNetworkServiceImpl(networkClient: networkClient)
    }
        
    // MARK: - BitcoinRateService
    
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        let analyticsService = Self.analyticsService()
        let networkReachability = Self.networkReachability()
        let bitcoinRateStore = Self.bitcoinRateStore()
        let bitcoinRateAnalyticsPlugin = BitcoinRateAnalyticsPlugin(analyticsService: analyticsService)
        let bitcoinNetworkService = Self.bitcoinRateNetworkService(bitcoinRateAnalyticsPlugin)
        let service = BitcoinRateServiceImpl(
            analyticsService: analyticsService, 
            networkService: bitcoinNetworkService,
            networkReachability: networkReachability,
            bitcoinRateStore: bitcoinRateStore
        )
        return { service }
    }()
    
    // MARK: - BitcoinRateStore
    
    static let bitcoinRateStore: PerformOnce<BitcoinRateStore> = {
        let coreDataStack = Self.coreDataStack()
        let store = BitcoinRateStoreImpl(database: coreDataStack)
        return { store }
    }()
    
    // MARK: - TransactionService
    
    static let transactionService: PerformOnce<TransactionService> = {
        let coreDataStack = Self.coreDataStack()
        let analyticsService = Self.analyticsService()
        let transactionStore = TransactionStoreImpl(database: coreDataStack)
        let service = TransactionServiceImpl(transactionStore: transactionStore, analyticsService: analyticsService)
        return { service }
    }()
    
    // MARK: - CoreDataStack
    
    static let coreDataStack: PerformOnce<CoreDataStack> = {
        let stack = CoreDataStack()
        return { stack }
    }()
}
