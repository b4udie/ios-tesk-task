//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation
import Combine

final class AddTransactionViewModel {

    // MARK: - Inputs/Outputs

    struct Inputs {
        let setAmount: (String) -> Void
        let selectCategory: (TransactionCategory) -> Void
        let addTap: () -> Void
        let cancelTap: () -> Void
    }

    struct Outputs {
        let isValid: AnyPublisher<Bool, Never>
        let selectedCategory: AnyPublisher<TransactionCategory, Never>
        let transactionAdded: AnyPublisher<Void, Never>
        let canceled: AnyPublisher<Void, Never>
    }

    let output: Outputs
    lazy var inputs: Inputs = {
        Inputs(
            setAmount: { [weak self] text in self?.amountSubject.send(text) },
            selectCategory: { [weak self] cat in self?.categorySubject.send(cat) },
            addTap: { [weak self] in self?.handleAdd() },
            cancelTap: { [weak self] in self?.canceledSubject.send(()) }
        )
    }()

    // MARK: - Dependencies

    private let transactionService: TransactionService

    // MARK: - Internal subjects

    private let amountSubject = CurrentValueSubject<String, Never>("")
    private let categorySubject = CurrentValueSubject<TransactionCategory, Never>(.other)
    private let addedSubject = PassthroughSubject<Void, Never>()
    private let canceledSubject = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(transactionService: TransactionService = ServicesAssembler.transactionService()) {
        self.transactionService = transactionService

        let isValid = amountSubject
            .map { Double($0) ?? 0 }
            .map { $0 > 0 }
            .removeDuplicates()
            .eraseToAnyPublisher()

        output = Outputs(
            isValid: isValid,
            selectedCategory: categorySubject.eraseToAnyPublisher(),
            transactionAdded: addedSubject.eraseToAnyPublisher(),
            canceled: canceledSubject.eraseToAnyPublisher()
        )
    }
}

// MARK: - Private

private extension AddTransactionViewModel {
    func handleAdd() {
        let amountText = amountSubject.value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let amount = Double(amountText), amount > 0 else { return }

        let transaction = Transaction(
            amount: amount,
            type: .expense(categorySubject.value)
        )
        
        transactionService.addTransaction(transaction)
        addedSubject.send(())
    }
}
