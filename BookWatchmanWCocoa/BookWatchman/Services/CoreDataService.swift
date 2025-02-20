//
//  CoreDataService.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

import CoreData
import Foundation
import UIKit

protocol CoreDataServicing {
    func fetchAllBooks() -> [Book]
    func fetchDbBookById(with id: UUID) -> DbBook?
    func addNewDbBook(book: Book)
    func deleteDbBookById(bookId: UUID)
    func updateDbBook(bookId: UUID, bookState: BookState, pagesRead: Int)
    func addSampleData()
}

final class CoreDataService: CoreDataServicing {
    private let moc: NSManagedObjectContext

    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchAllBooks() -> [Book] {
        fetchAllDbBooks().map { DbBook in
            let image: UIImage
            if let storedImageData = DbBook.imageData{
                image = UIImage(data: storedImageData) ?? UIImage()
            }else{
                image = UIImage(systemName: "books.vertical") ?? UIImage()
            }
            
            return Book(id: DbBook.id ?? UUID(),
                        title: DbBook.title ?? "",
                        author: DbBook.author ?? "",
                        pageCount: Int(DbBook.pageCount),
                        bookState: BookState(rawValue: DbBook.bookState) ?? .ToBeRead,
                        pagesRead: Int(DbBook.pagesRead),
                        genre: DbBook.genre ?? "",
                        bookDescription: DbBook.bookDescription ?? "",
                        isbn: DbBook.isbn ?? "",
                        image: image
            )
        }
    }
    
    func fetchAllDbBooks() -> [DbBook] {
        let request = NSFetchRequest<DbBook>(entityName: "DbBook")
        var dbBooks: [DbBook] = []
        
        do{
            dbBooks = try moc.fetch(request)
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
        
        return dbBooks
    }
    
    func fetchDbBookById(with id: UUID) -> DbBook? {
        let fetchRequest: NSFetchRequest<DbBook> = DbBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            return try moc.fetch(fetchRequest).first
        } catch {
            print("Error fetching books: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addNewDbBook(book: Book) {
        let newDbBook = DbBook(context: moc)
        
        newDbBook.id = book.id
        newDbBook.title = book.title
        newDbBook.author = book.author
        newDbBook.pageCount = Int16(book.pageCount)
        newDbBook.bookState = book.bookState.rawValue
        newDbBook.pagesRead = Int16(book.pagesRead)
        newDbBook.genre = book.genre
        newDbBook.bookDescription = book.bookDescription
        newDbBook.isbn = book.isbn
        newDbBook.imageData = book.image?.jpegData(compressionQuality: 0.8)
        
        save()
    }
    
    func deleteDbBookById(bookId: UUID) {
        guard let bookToDelete = fetchDbBookById(with: bookId) else {
            print("Book not found.")
            return
        }
        moc.delete(bookToDelete)
        save()
    }
    
    func updateDbBook(bookId: UUID, bookState: BookState, pagesRead: Int) {
        guard let bookToUpdate = fetchDbBookById(with: bookId) else {
            print("Book not found.")
            return
        }
        
        if bookToUpdate.bookState != bookState.rawValue {
            bookToUpdate.bookState = bookState.rawValue
        }
        if bookToUpdate.pagesRead != pagesRead {
            bookToUpdate.pagesRead = Int16(pagesRead)
        }

        save()
    }
    
    func addSampleData() {
        let b1 = Book(title: "Test Potter",
                      author: "Test Rowlings",
                      pageCount: 320,
                      bookState: BookState.ToBeRead,
                      pagesRead: 0,
                      genre: "Fiction",
                      bookDescription: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Praesent id justo in neque elementum ultrices. Etiam quis quam. Praesent id justo in neque elementum ultrices. Sed ac dolor sit amet purus malesuada congue. Fusce suscipit libero eget elit. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Nulla est. Vivamus porttitor turpis ac leo. Suspendisse sagittis ultrices augue. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Etiam egestas wisi a erat.",
                      isbn: "",
                      image: UIImage(named: "harry_potter_cover.jpg")
        )
        
        let b2 = Book(title: "Testro 1234",
                      author: "Test Glughovsky",
                      pageCount: 640,
                      bookState: BookState.Reading,
                      pagesRead: 60,
                      genre: "Post-apo",
                      bookDescription: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Praesent id justo in neque elementum ultrices. Etiam quis quam. Praesent id justo in neque elementum ultrices. Sed ac dolor sit amet purus malesuada congue. Fusce suscipit libero eget elit. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Nulla est. Vivamus porttitor turpis ac leo. Suspendisse sagittis ultrices augue. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Etiam egestas wisi a erat.",
                      isbn: "",
                      image: nil
        )
        
        addNewDbBook(book: b1)
        addNewDbBook(book: b2)
        addNewDbBook(book: .mock)
    }
    
    func save() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Cannot save MOC: \(error.localizedDescription)")
            }
        }
    }
}

final class MockCoreDataService: CoreDataServicing {    
    func fetchAllBooks() -> [Book] {
        return []
    }
    func fetchDbBookById(with id: UUID) -> DbBook? {
        return nil
    }
    func addNewDbBook(book: Book) {}
    func deleteDbBookById(bookId: UUID) {}
    func updateDbBook(bookId: UUID, bookState: BookState, pagesRead: Int) {}
    func addSampleData() {}
}
