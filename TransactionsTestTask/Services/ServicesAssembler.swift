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
        let bitcoinRateAnalyticsPlugin = BitcoinRateAnalyticsPlugin(analyticsService: analyticsService)
        let bitcoinNetworkService = Self.bitcoinRateNetworkService(bitcoinRateAnalyticsPlugin)
        let service = BitcoinRateServiceImpl(analyticsService: analyticsService, networkService: bitcoinNetworkService)
        return { service }
    }()
    
    // MARK: - TransactionService
    
     static let transactionService: PerformOnce<TransactionService> = {
         let service = TransactionServiceImpl()
         return { service }
     }()
}
