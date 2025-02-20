//
//  Endpoint.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var urlParameters: [String: Any] { get }

    func asURLRequest() throws -> URLRequest
}

extension Endpoint {
    var host: String {
        "https://www.googleapis.com/books/v1/"
    }

    var method: String {
        "GET"
    }

    var headers: [String: String] {
        [:]
    }

    func asURLRequest() throws -> URLRequest {

        guard let url = URL(string: host) else {
            throw APIError.urlRequestError
        }

        guard var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw APIError.urlRequestError
        }

        if !urlParameters.isEmpty {
            urlComponents.queryItems = urlParameters.map {
                URLQueryItem(name: $0, value: String(describing: $1))
            }
        }

        guard let url = urlComponents.url else {
            throw APIError.urlRequestError
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        

        return request
    }
}
