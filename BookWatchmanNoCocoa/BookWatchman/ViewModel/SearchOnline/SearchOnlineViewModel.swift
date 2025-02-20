//
//  SearchOnlineViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

class SearchOnlineViewModel: ObservableObject {
    private weak var coordinator: SearchOnlineViewEventHandling?
    let apiManager: APIManaging
    
    @Published var searchQuery: String = ""
    @Published var searchOption: SearchBarOption = .Title
    @Published var searchResults: [BookItem] = []
    @Published var selectedBook: BookItem? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    init(coordinator: SearchOnlineViewEventHandling? = nil,
         apiManager: APIManaging
    ) {
        self.coordinator = coordinator
        self.apiManager = apiManager
    }
    
    func send(_ action: Action) {
        switch action {
        case .didTapBook:
            guard let book = selectedBook else{
                return
            }
            coordinator?.handle(event: .AddBook(book))
        }
    }
    
    @MainActor
    func searchBooks() {
        guard !searchQuery.isEmpty else {
            errorMessage = "Zadejte text pro vyhledávání."
            return
        }
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return
        }
        let cleanApiKey = apiKey.replacingOccurrences(of: "\"", with: "")
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let formattedQuery = formatQuery(searchQuery)
                let endpoint = BookDataRouter.searchBooks(query: formattedQuery, apiKey: cleanApiKey)
                let response: BookResponse = try await apiManager.request(endpoint)
                self.searchResults = response.items
                isLoading = false
            } catch {
                errorMessage = "Chyba při vyhledávání knih: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    private func formatQuery(_ query: String) -> String {
        let prefix = searchOption.toQueryPrefix()
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return "\(prefix)\(trimmedQuery)"
    }
}

// MARK: Event
extension SearchOnlineViewModel {
    enum Event {
        case AddBook(BookItem)
    }
}

// MARK: Action
extension SearchOnlineViewModel {
    enum Action {
        case didTapBook
    }
}
