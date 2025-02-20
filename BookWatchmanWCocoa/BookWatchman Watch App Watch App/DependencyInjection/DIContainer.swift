//
//  DIContainer.swift
//  BookWatchman Watch App Watch App
//
//  Created by Tomáš Kudera on 02.01.2025.
//

@MainActor
final class DIContainer {
    let coreDataController: CoreDataController
    let coreDataService: CoreDataServicing

    init() {
        self.coreDataController = CoreDataController()
        self.coreDataService = CoreDataService(moc: coreDataController.container.viewContext)
    }
}
