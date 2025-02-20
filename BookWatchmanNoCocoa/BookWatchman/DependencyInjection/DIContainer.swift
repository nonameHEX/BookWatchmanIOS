//
//  DIContainer.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

@MainActor
final class DIContainer {
    // TODO vložit potřebný service atd. a pak initnout pro DI
    let coreDataController: CoreDataController
    let coreDataService: CoreDataServicing
    let apiManager: APIManaging

    init() {
        self.coreDataController = CoreDataController()
        self.coreDataService = CoreDataService(moc: coreDataController.container.viewContext)
        self.apiManager = APIManager()
    }
}
