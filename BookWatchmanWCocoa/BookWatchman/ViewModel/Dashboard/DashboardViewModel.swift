//
//  DashboardViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import Foundation

class DashboardViewModel: ObservableObject {
    private weak var coordinator: DashboardViewEventHandling?
    private let bookService: CoreDataServicing
    
    @Published private(set) var state = State()
    
    init(coordinator: DashboardViewEventHandling? = nil,
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
            initValues()
        case .didTapMapItem(_):
            return
        case .didRequestDataRefresh:
            return
        }
    }
    
    func initValues(){
        state.booksToBeRead = state.books.filter { $0.bookState == .ToBeRead }.count
        state.booksReading = state.books.filter { $0.bookState == .Reading }.count
        state.booksRead = state.books.filter { $0.bookState == .Read }.count
        
        state.totalPages = state.books.reduce(0) { $0 + $1.pageCount }
        state.pagesRead = state.books.reduce(0) { (result, book) in
            switch book.bookState {
            case .Read:
                return result + book.pageCount
            case .Reading:
                return result + book.pagesRead
            default:
                return result
            }
        }
    }
}

// MARK: Event
extension DashboardViewModel {
    enum Event {
        case mapDetail
    }
}

// MARK: Action
extension DashboardViewModel {
    enum Action {
        case didAppear
        case didTapMapItem(MapItem)
        case didRequestDataRefresh
    }
}

// MARK: State
extension DashboardViewModel {
    struct State {
        var books: [Book] = []
        var booksToBeRead: Int = 0
        var booksReading: Int = 0
        var booksRead: Int = 0
        var totalPages: Int = 0
        var pagesRead: Int = 0
    }
}
