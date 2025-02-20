//
//  APIError.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

enum APIError: Error {
    case urlRequestError
    case urlSessionError
    case parsingError
}
