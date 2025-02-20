//
//  Book.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import Foundation
import UIKit
import SwiftUI

struct Book: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var pageCount: Int
    var bookState: BookState
    var pagesRead: Int
    var genre: String
    var bookDescription: String
    var isbn: String
    var image: UIImage?
}

extension Book {
    static let mock = Book(title: "Test Potter",
                           author: "Test Rowlings",
                           pageCount: 320,
                           bookState: BookState.ToBeRead,
                           pagesRead: 0,
                           genre: "Fiction",
                           bookDescription: "Lorem ipsum",
                           isbn: "",
                           image: nil
             )
}

enum BookState: Int16, CaseIterable, Identifiable {
    var id: Self { self }
    
    case ToBeRead = 1
    case Reading = 2
    case Read = 3
    
    var name: String {
        switch self {
        case .ToBeRead:
            return "K přečtení"
        case .Reading:
            return "Rozečteno"
        case .Read:
            return "Přečteno"
        }
    }
    
    var color: Color {
        switch self {
        case .ToBeRead:
            return .blue
        case .Reading:
            return .orange
        case .Read:
            return .green
        }
    }
}

extension Book {
    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "id": id.uuidString,
            "title": title,
            "author": author,
            "pageCount": pageCount,
            "bookState": bookState.rawValue,
            "pagesRead": pagesRead,
            "genre": genre,
            "bookDescription": bookDescription,
            "isbn": isbn
        ]
        
        return dictionary
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> Book? {
        guard let idString = dictionary["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dictionary["title"] as? String,
              let author = dictionary["author"] as? String,
              let pageCount = dictionary["pageCount"] as? Int,
              let bookStateRaw = dictionary["bookState"] as? Int16,
              let bookState = BookState(rawValue: bookStateRaw),
              let pagesRead = dictionary["pagesRead"] as? Int,
              let genre = dictionary["genre"] as? String,
              let bookDescription = dictionary["bookDescription"] as? String,
              let isbn = dictionary["isbn"] as? String else {
            return nil
        }
        
        var image: UIImage? = nil
        if let imageData = dictionary["image"] as? Data {
            image = UIImage(data: imageData)
        }
        
        return Book(id: id,
                    title: title,
                    author: author,
                    pageCount: pageCount,
                    bookState: bookState,
                    pagesRead: pagesRead,
                    genre: genre,
                    bookDescription: bookDescription,
                    isbn: isbn,
                    image: image)
    }
}
