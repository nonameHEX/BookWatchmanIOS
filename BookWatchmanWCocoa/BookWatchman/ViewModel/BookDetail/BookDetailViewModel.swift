//
//  BookDetailViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

class BookDetailViewModel: ObservableObject {
    let bookService: CoreDataServicing
    
    @Published var book: Book?
    @Published var isEdited = false
    @Published var selectedBookState: BookState = BookState.ToBeRead

    @Published var pagesReadValue: Int = 0 {
        didSet {
            if var book = book {
                book.pagesRead = pagesReadValue
            }
        }
    }
    
    @Published var readingProgress: Float = 0
    
    init(bookService: CoreDataServicing,
         book: Book
    ) {
        self.bookService = bookService
        self.book = book
        
        selectedBookState = book.bookState
        pagesReadValue = book.pagesRead
        
        calculateProgress()
    }
    
    func calculateProgress(){
        if let book = book {
            readingProgress = Float(book.pagesRead) / Float(book.pageCount)
        }
    }
    
    func updateBookState(to newState: BookState) {
        if(book?.bookState != newState){
            book?.bookState = newState
            isEdited = true
        }
    }
    
    func updatePagesRead(to newCount: Int) {
        if(book?.pagesRead != newCount){
            book?.pagesRead = newCount
            isEdited = true
        }
        calculateProgress()
    }
    
    func saveBookUpdatedValues() {
        guard let book = book else { return }
        bookService.updateDbBook(bookId: book.id, bookState: book.bookState, pagesRead: book.pagesRead)
        isEdited = false
    }
}

// MARK: Action
extension BookDetailViewModel {
    enum Action {
        case didChangeBookState
        case didChangePagesReadCount
    }
}
