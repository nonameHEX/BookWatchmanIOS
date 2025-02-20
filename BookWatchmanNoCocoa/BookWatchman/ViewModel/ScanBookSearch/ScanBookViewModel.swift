//
//  ScanBookViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

class ScanBookViewModel: ObservableObject {
    private weak var coordinator: SearchOnlineViewEventHandling?
    let apiManager: APIManaging
    
    init(coordinator: SearchOnlineViewEventHandling? = nil, apiManager: APIManaging) {
        self.coordinator = coordinator
        self.apiManager = apiManager
    }
    
}

// MARK: Event
extension ScanBookViewModel {
    enum Event {
        case AddBook(BookItem)
    }
}

// MARK: Action
extension ScanBookViewModel {
    enum Action {
        case didTapBook
    }
}
