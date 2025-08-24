//
//  BaseCoordinator.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: Coordinator?
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func start(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
