//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Foundation
import Combine

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests
protocol BitcoinRateService: AnyObject {
    var ratePublisher: AnyPublisher<Double, Never> { get }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    private let rateSubject = CurrentValueSubject<Double, Never>(0.0)
    private var timer: Timer?
    private let analyticsService: AnalyticsService
    private let networkService: BitcoinRateNetworkService
    private let networkReachability: NetworkReachability
    private let bitcoinRateStore: BitcoinRateStore
    private var cancellables = Set<AnyCancellable>()
    
    var ratePublisher: AnyPublisher<Double, Never> {
        rateSubject.eraseToAnyPublisher()
    }
    
    init(
        analyticsService: AnalyticsService, 
        networkService: BitcoinRateNetworkService,
        networkReachability: NetworkReachability,
        bitcoinRateStore: BitcoinRateStore
    ) {
        self.analyticsService = analyticsService
        self.networkService = networkService
        self.networkReachability = networkReachability
        self.bitcoinRateStore = bitcoinRateStore
        
        loadCachedRate()
        setupNetworkMonitoring()
    }
    
    deinit {
        stopFetching()
    }
    
    private func startFetching() {
        fetchRate()
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
            self?.fetchRate()
        }
    }
    
    private func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    private func setupNetworkMonitoring() {
        networkReachability.connectionStatusPublisher
            .sink { [weak self] isConnected in
                if isConnected {
                    self?.startFetching()
                } else {
                    self?.stopFetching()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchRate() {
        guard networkReachability.isConnected else {
            return
        }
        
        networkService.fetchBitcoinRate()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        let errorEvent = ErrorEvent(error: error, context: "bitcoin_rate_fetch")
                        self?.analyticsService.trackEvent(errorEvent)
                        self?.loadCachedRate()
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    let bitcoinRateBO = BitcoinRateBO(from: response)
                    self.rateSubject.send(bitcoinRateBO.rate)
                    
                    Task {
                        try await self.bitcoinRateStore.saveRate(bitcoinRateBO.rate)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadCachedRate() {
        do {
            if let cachedRate = try bitcoinRateStore.getCurrentRate() {
                rateSubject.send(cachedRate)
            }
        } catch {
            let errorEvent = ErrorEvent(error: error, context: "load_cached_bitcoin_rate")
            analyticsService.trackEvent(errorEvent)
        }
    }
}
