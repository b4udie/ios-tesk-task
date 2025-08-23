//
//  MainViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Public Properties
    
    @Published var balance: Double = 0.0
    @Published var bitcoinRate: Double = 0.0
    @Published var transactionGroups: [TransactionGroupViewModel] = []
    @Published var isLoading: Bool = false
    
    let onAddTransaction = PassthroughSubject<Void, Never>()
    let onAddIncome = PassthroughSubject<String, Never>()
    let onShowAddIncomeAlert = PassthroughSubject<Void, Never>()
    let onShowAddIncomeErrorAlert = PassthroughSubject<String, Never>()
    
    var hasMorePages: Bool {
        transactionService.hasMorePages
    }
    
    // MARK: - Private Properties
    
    private let transactionService: TransactionService
    private let bitcoinRateService: BitcoinRateService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    init(transactionService: TransactionService = ServicesAssembler.transactionService(),
         bitcoinRateService: BitcoinRateService = ServicesAssembler.bitcoinRateService()) {
        self.transactionService = transactionService
        self.bitcoinRateService = bitcoinRateService
        setupBindings()
    }
    
    // MARK: - Public Methods
    
    func addTransactionTapped() {
        onAddTransaction.send()
    }
    
    func addIncomeTapped() {
        onShowAddIncomeAlert.send()
    }
    
    func loadMoreTransactions() {
        transactionService.loadNextPage()
    }
}

// MARK: - Private Methods

private extension MainViewModel {
    func setupBindings() {
        transactionService.balancePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                self?.balance = balance
            }
            .store(in: &cancellables)

        transactionService.transactionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                self?.transactionGroups = groups.map { TransactionGroupViewModel(from: $0) }
            }
            .store(in: &cancellables)

        bitcoinRateService.ratePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                self?.bitcoinRate = rate
            }
            .store(in: &cancellables)

        onAddIncome
            .sink { [weak self] value in
                if let amount = Double(value), amount > 0.0 {
                    self?.transactionService.addIncome(amount)
                } else {
                    self?.onShowAddIncomeErrorAlert.send("Incorrect input")
                }
            }
            .store(in: &cancellables)
    }
}
