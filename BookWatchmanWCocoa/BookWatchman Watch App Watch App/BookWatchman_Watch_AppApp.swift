//
//  BookWatchman_Watch_AppApp.swift
//  BookWatchman Watch App Watch App
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import SwiftUI

@main
@MainActor
struct BookWatchman_Watch_App_Watch_AppApp: App {
    private let container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                connector: PhoneConnector(bookService: container.coreDataService,
                                          viewModel: BookshelfViewModel(
                                            bookService: container.coreDataService)
                                         ),
                dashboardVM: DashboardViewModel(bookService: container.coreDataService),
                bookshelfVM: BookshelfViewModel(bookService: container.coreDataService)
            )
        }
    }
}
