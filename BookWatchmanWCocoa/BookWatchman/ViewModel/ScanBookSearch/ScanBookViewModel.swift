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
    
    @Published var state = State()
    
    init(coordinator: SearchOnlineViewEventHandling? = nil,
         apiManager: APIManaging
    ) {
        self.coordinator = coordinator
        self.apiManager = apiManager
    }
    
    @MainActor
    func send(_ action: Action) {
        switch action {
        case .didTapBook:
            guard let book = state.selectedBook else{
                return
            }
            coordinator?.handle(event: .AddBook(book))
        case .didTapPhoto:
            state.searchQuery = ""
            state.searchResults = []
        case .didReadPhotoText(let recognizedText):
            state.searchQuery = recognizedText
            searchBooks()
        }
    }
    
    @MainActor
    func searchBooks() {
        guard !state.searchQuery.isEmpty else {
            state.errorMessage = "Zadejte text pro vyhledávání."
            return
        }
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            return
        }
        let cleanApiKey = apiKey.replacingOccurrences(of: "\"", with: "")
        
        state.isLoading = true
        state.errorMessage = nil
        
        Task {
            do {
                let formattedQuery = formatQuery(state.searchQuery)
                print("formatted query: \(formattedQuery)")
                let endpoint = BookDataRouter.searchBooks(query: formattedQuery, apiKey: cleanApiKey)
                let response: BookResponse = try await apiManager.request(endpoint)
                self.state.searchResults = response.items
                state.isLoading = false
            } catch {
                state.errorMessage = "Chyba při vyhledávání knih: \(error.localizedDescription)"
                state.isLoading = false
            }
        }
    }
    
    private func formatQuery(_ query: String) -> String {
        let cleanedQuery = cleanSearchQuery(query)
        
        let prefix = state.searchOption.toQueryPrefix()
        let trimmedQuery = cleanedQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(prefix)\(trimmedQuery)"
    }
    
    private func cleanSearchQuery(_ query: String) -> String {
        let noNewLines = query.replacingOccurrences(of: "\n", with: " ")
        let cleanedQuery = noNewLines.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return cleanedQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
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
        case didTapPhoto
        case didReadPhotoText(String)
    }
}

// MARK: State
extension ScanBookViewModel {
    struct State {
        var searchQuery: String = ""
        var searchOption: SearchBarOption = .Title
        var searchResults: [BookItem] = []
        var selectedBook: BookItem? = nil
        var isLoading: Bool = false
        var errorMessage: String? = nil
    }
}
