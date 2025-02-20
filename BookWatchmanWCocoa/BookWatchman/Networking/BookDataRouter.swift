//
//  BookDataRouter.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

enum BookDataRouter: Endpoint {
    case searchBooks(query: String, apiKey: String)
    case getBookById(id: String)

    var path: String {
        switch self {
        case .searchBooks:
            return "volumes"
        case .getBookById(let id):
            return "volumes/\(id)"
        }
    }

    var urlParameters: [String : Any] {
        switch self {
        case .searchBooks(let query, let apiKey):
        return [
            "q": query,
            "key": apiKey
        ]
        case .getBookById:
            return [:] // No query parameters needed for getBookById
        }
    }
}
