//
//  BookshelfViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

import Foundation

class BookshelfViewModel: ObservableObject {
    private weak var coordinator: BookshelfViewEventHandling?
    let bookService: CoreDataServicing
    
    @Published private(set) var state = State()
    
    init(coordinator: BookshelfViewEventHandling? = nil,
         bookService: CoreDataServicing) {
        self.coordinator = coordinator
        self.bookService = bookService
    }
    
    func send(_ action: Action) {
        switch action {
            
        case .didAppear:
            let books = bookService.fetchAllBooks()
            state.books = books
            
            if state.books.isEmpty {
                //bookService.addSampleData()
                //state.books = bookService.fetchAllBooks()
            }
        case .didTapBook(let book):
            coordinator?.handle(event: .bookDetail(book))
        case .didTapDeleteBook(let book):
            bookService.deleteDbBookById(bookId: book.id)
            state.books = bookService.fetchAllBooks()
        case .didTapAddNewBookSearchOnline:
            coordinator?.handle(event: .searchOnline)
        case .didTapAddNewBookScanBookOnline:
            coordinator?.handle(event: .scanSearch)
        case .didTapAddNewBookManual:
            coordinator?.handle(event: .manualAdd)
        case .didRequestDataRefresh:
            state.books = bookService.fetchAllBooks()
        }
    }
}

// MARK: Event
extension BookshelfViewModel {
    enum Event {
        case bookDetail(Book)
        case searchOnline
        case scanSearch
        case manualAdd
    }
}

// MARK: Action
extension BookshelfViewModel {
    enum Action {
        case didAppear
        case didTapBook(Book)
        case didTapDeleteBook(Book)
        case didTapAddNewBookSearchOnline
        case didTapAddNewBookScanBookOnline
        case didTapAddNewBookManual
        case didRequestDataRefresh
    }
}

// MARK: State
extension BookshelfViewModel {
    struct State {
        var books: [Book] = []
    }
}
