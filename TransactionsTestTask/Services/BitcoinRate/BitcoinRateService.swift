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
    func startFetching()
    func stopFetching()
}

struct BitcoinRateResponse: Codable {
    let USD: CurrencyRate
    
    struct CurrencyRate: Codable {
        let last: Double
        let symbol: String
    }
}

final class BitcoinRateServiceImpl: BitcoinRateService {
    private let rateSubject = CurrentValueSubject<Double, Never>(0.0)
    private var timer: Timer?
    private let analyticsService: AnalyticsService
    private let networkService: BitcoinRateNetworkService
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "cached_bitcoin_rate"
    private var cancellables = Set<AnyCancellable>()
    
    var ratePublisher: AnyPublisher<Double, Never> {
        rateSubject.eraseToAnyPublisher()
    }
    
    init(analyticsService: AnalyticsService, networkService: BitcoinRateNetworkService) {
        self.analyticsService = analyticsService
        self.networkService = networkService
        loadCachedRate()
    }
    
    func startFetching() {
        fetchRate()
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
            self?.fetchRate()
        }
    }
    
    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }
    
    private func fetchRate() {
        networkService.fetchBitcoinRate()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching Bitcoin rate: \(error)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    let rate = response.USD.last
                    self.rateSubject.send(rate)
                    self.cacheRate(rate)
                }
            )
            .store(in: &cancellables)
    }
    
    private func cacheRate(_ rate: Double) {
        userDefaults.set(rate, forKey: cacheKey)
    }
    
    private func loadCachedRate() {
        let cachedRate = userDefaults.double(forKey: cacheKey)
        if cachedRate > 0 {
            rateSubject.send(cachedRate)
        }
    }
}
