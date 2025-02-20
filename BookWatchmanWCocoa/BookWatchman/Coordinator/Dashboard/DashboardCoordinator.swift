//
//  DashboardCoordinator.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.12.2024.
//

import SwiftUI

@MainActor
final class DashboardCoordinator {
    let container: DIContainer
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private lazy var viewModel = DashboardViewModel(
        coordinator: self,
        bookService: container.coreDataService
    )
    
    init(container: DIContainer) {
        self.container = container
        self.navigationController = UINavigationController()

        start()
    }
}

extension DashboardCoordinator: Coordinator {
    func start() {
        let signInViewController = makeDashboardView()
        navigationController.setViewControllers([signInViewController], animated: true)
    }
}

// MARK: Factories
// TODO správnou implementaci
private extension DashboardCoordinator {
    func makeDashboardView() -> UIViewController {
        let view = DashboardView(
            dashboardVM: self.viewModel,
            connector: WatchConnector(
                viewModel: BookshelfViewModel(bookService: self.container.coreDataService),
                bookService: self.container.coreDataService
            )
        )
        
        return UIHostingController(rootView: view)
    }
}


// MARK: Navigating
// TODO správnou implementaci
extension DashboardCoordinator: DashboardViewEventHandling {
    func handle(event: DashboardViewModel.Event){
        switch event {
        case .mapDetail:
            let viewController = makeDashboardView()
            navigationController.present(viewController, animated: true)
        }
    }
}
