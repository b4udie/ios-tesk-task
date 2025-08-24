//
//  AppCoordinator.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    override func start() {
        showMain()
    }

    private func showMain() {
        removeChildCoordinators()

        let nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()

        let main = MainCoordinator()
        main.navigationController = nav
        start(coordinator: main)
    }
}

