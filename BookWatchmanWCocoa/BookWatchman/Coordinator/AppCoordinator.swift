//
//  AppCoordinator.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import UIKit

@MainActor
final class AppCoordinator {
    let container: DIContainer
    var childCoordinators = [Coordinator]()
    var rootCoordinator: Coordinator?
    let window: UIWindow

    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container

        start(container: container)
    }
}

extension AppCoordinator {
    func start(container: DIContainer) {
        let coordinator = BookWatchmanCoordinator(container: container)
        childCoordinators.append(coordinator)
        rootCoordinator = coordinator
        window.rootViewController = coordinator.tabBarController
        window.makeKeyAndVisible()
    }
}
