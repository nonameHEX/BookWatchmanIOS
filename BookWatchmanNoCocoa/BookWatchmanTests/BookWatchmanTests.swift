//
//  BookWatchmanTests.swift
//  BookWatchmanTests
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import XCTest
import Combine

@testable import BookWatchman

final class BookWatchmanTests: XCTestCase {
    
    private var bookService: CoreDataServicing!
    
    override func setUp() async throws {
        bookService = CoreDataService()
        let books: [Book] = [
            Book(title: "Book 1", author: "Author 1", pageCount: 100, bookState: .Reading, pagesRead: 50, genre: "Fiction", bookDescription: "Test", isbn: "123", image: nil),
            Book(title: "Book 2", author: "Author 2", pageCount: 200, bookState: .Read, pagesRead: 200, genre: "Fiction", bookDescription: "Test", isbn: "456", image: nil),
            Book(title: "Book 3", author: "Author 3", pageCount: 150, bookState: .ToBeRead, pagesRead: 0, genre: "Non-Fiction", bookDescription: "Test", isbn: "789", image: nil)
        ]
        for book in books {
            bookService.addNewDbBook(book: book)
        }
    }

    override func tearDown() async throws {
        try await super.tearDown()
        bookService = nil
    }

    func test_booksAreFilteredCorrectly() throws {
        let viewModel = DashboardViewModel(bookService: bookService)
        
        // Send action to load books
        viewModel.send(.didAppear)
        print(viewModel.state.books)
        
        // Assert the books are correctly filtered into the state
        XCTAssertEqual(viewModel.state.booksToBeRead, 1)
        XCTAssertEqual(viewModel.state.booksReading, 1)
        XCTAssertEqual(viewModel.state.booksRead, 1)
        
        XCTAssertEqual(viewModel.state.books.count, 3)
    }
    
    func test_totalPagesAndPagesRead() throws {
        let viewModel = DashboardViewModel(bookService: bookService)
        
        viewModel.send(.didAppear)
        
        XCTAssertEqual(viewModel.state.totalPages, 450)
        
        XCTAssertEqual(viewModel.state.pagesRead, 250)
    }
    
    func test_booksStateUpdate() throws {
        let viewModel = DashboardViewModel(bookService: bookService)
        
        viewModel.send(.didAppear)
        
        if let firstBook = viewModel.state.books.first {
            bookService.updateDbBook(bookId: firstBook.id, bookState: .Read, pagesRead: 0)
        }
        
        viewModel.send(.didAppear)
        
        XCTAssertEqual(viewModel.state.booksReading, 0)
        XCTAssertEqual(viewModel.state.booksRead, 2)
    }
    
    func test_booksAreCategorizedAfterAddingNewBook() throws {
        let viewModel = DashboardViewModel(bookService: bookService)
        
        viewModel.send(.didAppear)
        XCTAssertEqual(viewModel.state.books.count, 3)
        
        let newBook = Book(title: "Book 4", author: "Author 4", pageCount: 120, bookState: .Reading, pagesRead: 60, genre: "Fiction", bookDescription: "Test", isbn: "999", image: nil)
        bookService.addNewDbBook(book: newBook)
        
        viewModel.send(.didAppear)
        
        XCTAssertEqual(viewModel.state.books.count, 4)
        XCTAssertEqual(viewModel.state.booksReading, 2)
    }
}
