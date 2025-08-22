//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class AppCoordinator: BaseCoordinator {
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        window.makeKeyAndVisible()
        showMainScreen()
    }
    
    private func showMainScreen() {
        removeChildCoordinators()
        
        let coordinator = MainCoordinator()
        coordinator.navigationController = UINavigationController()
        start(coordinator: coordinator)
        
        window.rootViewController = coordinator.navigationController
    }
}

