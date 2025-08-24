//
//  MainViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation
import Combine

final class MainViewModel {

    // MARK: Inputs/Outputs

    struct Inputs {
        let addTransactionTap: () -> Void
        let addIncomeTap: () -> Void
        let incomeEntered: (String) -> Void
        let loadMore: () -> Void
    }

    struct Outputs {
        let balance: AnyPublisher<Double, Never>
        let bitcoinRate: AnyPublisher<Double, Never>
        let transactionGroups: AnyPublisher<[TransactionGroupViewModel], Never>

        let showAddTransaction: AnyPublisher<Void, Never>
        let showAddIncomeAlert: AnyPublisher<Void, Never>
        let showError: AnyPublisher<String, Never>
    }

    let output: Outputs
    lazy var inputs: Inputs = {
        Inputs(
            addTransactionTap: { [weak self] in self?.addTransactionSubject.send(()) },
            addIncomeTap: { [weak self] in self?.addIncomeTapSubject.send(()) },
            incomeEntered: { [weak self] text in self?.incomeEnteredSubject.send(text) },
            loadMore: { [weak self] in self?.loadMoreSubject.send(()) }
        )
    }()

    // MARK: Dependencies

    private let transactionService: TransactionService
    private let bitcoinRateService: BitcoinRateService

    // MARK: Internal subjects

    private let addTransactionSubject = PassthroughSubject<Void, Never>()
    private let addIncomeTapSubject = PassthroughSubject<Void, Never>()
    private let incomeEnteredSubject = PassthroughSubject<String, Never>()
    private let loadMoreSubject = PassthroughSubject<Void, Never>()
    private let showErrorSubject = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init(
        transactionService: TransactionService = ServicesAssembler.transactionService(),
        bitcoinRateService: BitcoinRateService = ServicesAssembler.bitcoinRateService()
    ) {
        self.transactionService = transactionService
        self.bitcoinRateService = bitcoinRateService

        let balance = transactionService.balancePublisher.eraseToAnyPublisher()
        let groups = transactionService.transactionsPublisher
            .map { $0.map { TransactionGroupViewModel(from: $0) } }
            .eraseToAnyPublisher()
        let rate = bitcoinRateService.ratePublisher.eraseToAnyPublisher()

        output = Outputs(
            balance: balance,
            bitcoinRate: rate,
            transactionGroups: groups,
            showAddTransaction: addTransactionSubject.eraseToAnyPublisher(),
            showAddIncomeAlert: addIncomeTapSubject.eraseToAnyPublisher(),
            showError: showErrorSubject.eraseToAnyPublisher()
        )

        incomeEnteredSubject
            .sink { [weak self] text in
                guard let self else { return }
                if let amount = Double(text), amount > 0 {
                    self.transactionService.addIncome(amount)
                } else {
                    self.showErrorSubject.send("Incorrect input")
                }
            }
            .store(in: &cancellables)

        loadMoreSubject
            .sink { [weak self] in self?.transactionService.loadNextPage() }
            .store(in: &cancellables)
    }
}
