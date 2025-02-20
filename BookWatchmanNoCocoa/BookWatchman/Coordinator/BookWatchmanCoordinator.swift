//
//  BookWatchmanCoordinator.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import SwiftUI

@MainActor
final class BookWatchmanCoordinator {
    let container: DIContainer
    var childCoordinators: [Coordinator] = []
    let tabBarController: UITabBarController
    
    init(container: DIContainer) {
        self.container = container
        self.tabBarController = UITabBarController()

        start()
    }
}

extension BookWatchmanCoordinator: Coordinator {
    func start() {
        let dashboardCoordinator = DashboardCoordinator(container: container)
        let bookshelfCoordinator = BookshelfCoordinator(container: container)
        
        childCoordinators.append(dashboardCoordinator)
        childCoordinators.append(bookshelfCoordinator)
        
        dashboardCoordinator.start()
        bookshelfCoordinator.start()
        
        tabBarController.viewControllers = [
            dashboardCoordinator.navigationController,
            bookshelfCoordinator.navigationController
        ]
        
        tabBarController.viewControllers?.enumerated().forEach { index, controller in
            if let navigationController = controller as? UINavigationController {
                switch index {
                case 0:
                    navigationController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
                case 1:
                    navigationController.tabBarItem = UITabBarItem(title: "Knihovna", image: UIImage(systemName: "books.vertical"), tag: 1)
                default:
                    break
                }
            }
        }
    }
}
