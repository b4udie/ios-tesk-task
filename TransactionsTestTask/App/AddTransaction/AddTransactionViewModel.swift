//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import Foundation
import Combine

final class AddTransactionViewModel: ObservableObject {
    // MARK: - Public Properties

    @Published var amount: String = ""
    @Published var selectedCategory: TransactionCategory = .other
    @Published var isValid: Bool = false
    
    let onTransactionAdded = PassthroughSubject<Void, Never>()
    let onCancel = PassthroughSubject<Void, Never>()
    
    // MARK: - Private Properties

    private let transactionService: TransactionService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle

    init(transactionService: TransactionService = ServicesAssembler.transactionService()) {
        self.transactionService = transactionService
        
        setupBindings()
    }
    
    // MARK: - Public Methods

    func addTransaction() {
        guard let amountValue = Double(amount), amountValue > 0 else { return }
        
        let transaction = Transaction(
            amount: amountValue,
            type: .expense(selectedCategory)
        )
        
        transactionService.addTransaction(transaction)
        onTransactionAdded.send()
    }
    
    func cancel() {
        onCancel.send()
    }
    
    func setCategory(_ category: TransactionCategory) {
        selectedCategory = category
    }
}

// MARK: - Private Methods

private extension AddTransactionViewModel {
    func setupBindings() {
        $amount
            .map { !$0.isEmpty && Double($0) != nil && Double($0)! > 0 }
            .sink { [weak self] isValid in
                self?.isValid = isValid
            }
            .store(in: &cancellables)
    }
}
