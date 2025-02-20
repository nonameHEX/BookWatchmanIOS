//
//  SearchBarOption.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 27.12.2024.
//

import Foundation

enum SearchBarOption: Int16, CaseIterable, Identifiable {
    var id: Self { self }
    
    case Title = 1
    case Author = 2

    func toQueryPrefix() -> String {
        switch self {
        case .Title:
            return "intitle:"
        case .Author:
            return "inauthor:"
        }
    }

    var name: String {
        switch self {
        case .Title:
            return "Název"
        case .Author:
            return "Autor"
        }
    }
}
