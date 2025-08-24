//
//  AddTransactionCoordinator.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class AddTransactionCoordinator: BaseCoordinator {
    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func start() {
        let viewModel = AddTransactionViewModel()
        let viewController = AddTransactionViewController(viewModel: viewModel)

        viewModel.output.transactionAdded
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController.popViewController(animated: true)
                self.parentCoordinator?.didFinish(coordinator: self)
            }
            .store(in: &cancellables)

        viewModel.output.canceled
            .sink { [weak self] in
                guard let self else { return }
                self.navigationController.popViewController(animated: true)
                self.parentCoordinator?.didFinish(coordinator: self)
            }
            .store(in: &cancellables)

        navigationController.pushViewController(viewController, animated: true)
    }
}
