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
        
        viewModel.onAddTransaction
            .sink { [weak self] in
                self?.showAddTransaction()
            }
            .store(in: &cancellables)
        
        viewModel.onShowAddIncomeAlert
            .sink { [weak self] in
                self?.showAddIncomeAlert()
            }
            .store(in: &cancellables)
        
        viewModel.onShowAddIncomeErrorAlert
            .sink { [weak self] message in
                self?.showErrorAlert(with: message)
            }
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
        
        alert.addTextField { textField in
            textField.placeholder = "0.0"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text {
                self?.viewModel?.onAddIncome.send(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        navigationController.present(alert, animated: true)
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        navigationController.present(alert, animated: true)
    }
}
