//
//  BookshelfCoordinator.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.12.2024.
//

import SwiftUI

@MainActor
final class BookshelfCoordinator {
    let container: DIContainer
    let connector: WatchConnector
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private lazy var viewModel = BookshelfViewModel(
        coordinator: self,
        bookService: container.coreDataService
    )
    
    init(container: DIContainer) {
        self.container = container
        self.navigationController = UINavigationController()
        self.connector = WatchConnector(
            viewModel: BookshelfViewModel(bookService: container.coreDataService),
            bookService: container.coreDataService)
        start()
    }
}

extension BookshelfCoordinator: Coordinator {
    func start() {
        let signInViewController = makeBookshelfView()
        navigationController.setViewControllers([signInViewController], animated: true)
    }
    
    func popBackToMainMenuBookshelf() {
        if let mainMenuViewController = navigationController.viewControllers.first(where: { $0 is UIHostingController<BookshelfView> }) {
            navigationController.popToViewController(mainMenuViewController, animated: true)
        }
    }
}

// MARK: Factories
private extension BookshelfCoordinator {
    func makeBookshelfView() -> UIViewController {
        let view = BookshelfView(
            bookshelfVM: self.viewModel,
            connector: WatchConnector(
                viewModel: self.viewModel,
                bookService: self.container.coreDataService
            )
        )
        
        return UIHostingController(rootView: view)
    }
    
    func makeBookDetailView(book: Book) -> UIViewController {
        let viewModel = BookDetailViewModel(
            bookService: self.container.coreDataService,
            book: book
        )
        let view = BookDetailView(
            coordinator: self,
            bookDetailVM: viewModel,
            bookshelfVM: self.viewModel,
            connector: self.connector
        )
        
        return UIHostingController(rootView: view)
    }
    
    func makeSearchOnlineView() -> UIViewController {
        let viewModel = SearchOnlineViewModel(
            coordinator: self,
            apiManager: APIManager()
        )
        
        let view = SearchOnlineView(
            searchOnlineVM: viewModel
        )
        
        return UIHostingController(rootView: view)
    }
    
    func makeScanBookView() -> UIViewController {
        let viewmodel = ScanBookViewModel(
            coordinator: self,
            apiManager: APIManager()
        )
        let view = ScanBookView(
            scanBookVM: viewmodel
        )
        
        return UIHostingController(rootView: view)
    }
    
    func makeAddBookView(bookItem: BookItem?) -> UIViewController {
        let viewModel = AddBookViewModel(
            coordinator: self,
            bookService: self.container.coreDataService,
            bookItem: bookItem,
            connector: self.connector
        )
        let view = AddBookView(
            addBookVM: viewModel
        )
        
        return UIHostingController(rootView: view)
    }
}


// MARK: Navigating
extension BookshelfCoordinator: BookshelfViewEventHandling {
    func handle(event: BookshelfViewModel.Event) {
        switch event {
            
        case .bookDetail(let book):
            let viewController = makeBookDetailView(book: book)
            
            navigationController.present(viewController, animated: true)
        case .searchOnline:
            let viewController = makeSearchOnlineView()
            print("Search online")
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        case .scanSearch:
            let viewController = makeScanBookView()
            print("Scan search")
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        case .manualAdd:
            let viewController = makeAddBookView(bookItem: nil)
            print("Manual add")
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension BookshelfCoordinator: BookDetailViewEventHandling {
    func handle(event: BookDetailView.Event) {
        switch event {
            
        case .close:
            navigationController.topViewController?.dismiss(animated: true)
        }
        
    }
}

extension BookshelfCoordinator: SearchOnlineViewEventHandling {
    func handle(event: SearchOnlineViewModel.Event) {
        switch event {
            
        case .AddBook(let bookItem):
            let viewController = makeAddBookView(bookItem: bookItem)
            print("Add book from search")
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}

extension BookshelfCoordinator: AddBookViewEventHandling {
    func handle(event: AddBookViewModel.Event) {
        switch event {
            
        case .bookAdded:
            popBackToMainMenuBookshelf()
        }
    }
}
