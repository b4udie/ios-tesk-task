//
//  MainCoordinator.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class MainCoordinator: BaseCoordinator {
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: MainViewModel?

    // MARK: - Lifecycle
    
    override func start() {
        let viewModel = MainViewModel()
        let viewController = MainViewController(viewModel: viewModel)
        
        viewModel.output.showAddTransaction
            .sink { [weak self] in self?.showAddTransaction() }
            .store(in: &cancellables)

        viewModel.output.showAddIncomeAlert
            .sink { [weak self] in self?.showAddIncomeAlert() }
            .store(in: &cancellables)

        viewModel.output.showError
            .sink { [weak self] message in self?.showErrorAlert(with: message) }
            .store(in: &cancellables)

        self.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }
}

// MARK: - Private Methods

private extension MainCoordinator {
    func showAddTransaction() {
        let coordinator = AddTransactionCoordinator()
        coordinator.navigationController = navigationController
        start(coordinator: coordinator)
    }
    
    func showAddIncomeAlert() {
        let alert = UIAlertController(
            title: "Add income",
            message: "Enter amount of Bitcoins",
            preferredStyle: .alert
        )
        
        alert.addTextField {
            $0.placeholder = "0.0"
            $0.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            guard
                let viewModel = self?.viewModel,
                let text = alert?.textFields?.first?.text
            else { return }
            viewModel.inputs.incomeEntered(text)
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController.present(alert, animated: true)
    }
}
