//
//  CoreDataTests.swift
//  BookWatchmanTests
//
//  Created by Tomáš Kudera on 13.01.2025.
//

import XCTest

@testable import BookWatchman

final class CoreDataTests: XCTestCase {
    private var bookService: CoreDataServicing!
    
    override func setUp() async throws {
        bookService = CoreDataService()
    }

    override func tearDown() async throws {
        try await super.tearDown()
        bookService = nil
    }
    
    func test_addNewDbBook() throws {
        let book = Book.mock
        
        bookService.addNewDbBook(book: book)
        let fetchedBooks = bookService.fetchAllBooks()
        
        XCTAssertEqual(fetchedBooks.count, 1)
        XCTAssertEqual(fetchedBooks.first?.title, book.title)
    }
    
    func test_fetchDbBookById() throws {
        let book = Book.mock
        bookService.addNewDbBook(book: book)
        
        let fetchedBook = bookService.fetchDbBookById(with: book.id)
        
        XCTAssertNotNil(fetchedBook)
        XCTAssertEqual(fetchedBook?.title, book.title)
    }
    
    func test_deleteDbBookById() throws {
        let book = Book.mock
        bookService.addNewDbBook(book: book)
        
        bookService.deleteDbBookById(bookId: book.id)
        let fetchedBooks = bookService.fetchAllBooks()
        
        XCTAssertTrue(fetchedBooks.isEmpty)
    }
    
    func test_updateDbBook() throws {
        let book = Book.mock
        bookService.addNewDbBook(book: book)
        
        bookService.updateDbBook(bookId: book.id, bookState: .Read, pagesRead: 320)
        let updatedBook = bookService.fetchDbBookById(with: book.id)
        
        XCTAssertEqual(updatedBook?.bookState, BookState.Read.rawValue)
        XCTAssertEqual(updatedBook?.pagesRead, 320)
    }
}
