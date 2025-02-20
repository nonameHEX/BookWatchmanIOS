//
//  ApiManagerMock.swift
//  BookWatchmanTests
//
//  Created by Tomáš Kudera on 13.01.2025.
//

import Foundation

@testable import BookWatchman

class ApiManagerMock: APIManaging {
    let toReturn: Result<Decodable, Error>

    init(toReturn: Result<Decodable, Error>) {
        self.toReturn = toReturn
    }
    
    func request<T>(_ endpoint: any BookWatchman.Endpoint) async throws -> T where T : Decodable {
        switch toReturn {
        case .success(let decodable):
            // Try casting the Decodable result to the expected type
            guard let result = decodable as? T else {
                throw NSError(domain: "ApiManagerMockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast to expected type \(T.self)"])
            }
            return result
        case .failure(let error):
            throw error
        }
    }
}
