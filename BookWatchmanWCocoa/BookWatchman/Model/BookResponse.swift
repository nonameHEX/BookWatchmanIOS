//
//  BookResponse.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation

struct BookResponse: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]
}

// MARK: - BookItem
struct BookItem: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
    let accessInfo: AccessInfo
    let searchInfo: SearchInfo?
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let readingModes: ReadingModes?
    var pageCount: Int?
    var printedPageCount: Int?
    let printType: String?
    let categories: [String]?
    let maturityRating: String?
    let allowAnonLogging: Bool?
    let contentVersion: String?
    let panelizationSummary: PanelizationSummary?
    let imageLinks: ImageLinks?
    let language: String?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

// MARK: - ReadingModes
struct ReadingModes: Codable {
    let text: Bool?
    let image: Bool?
}

// MARK: - PanelizationSummary
struct PanelizationSummary: Codable {
    let containsEpubBubbles: Bool?
    let containsImageBubbles: Bool?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let country: String?
    let saleability: String?
    let isEbook: Bool?
}

// MARK: - AccessInfo
struct AccessInfo: Codable {
    let country: String?
    let viewability: String?
    let embeddable: Bool?
    let publicDomain: Bool?
    let textToSpeechPermission: String?
    let epub: Epub?
    let pdf: Pdf?
    let webReaderLink: String?
    let accessViewStatus: String?
    let quoteSharingAllowed: Bool?
}

// MARK: - Epub
struct Epub: Codable {
    let isAvailable: Bool?
}

// MARK: - Pdf
struct Pdf: Codable {
    let isAvailable: Bool?
}

// MARK: - SearchInfo
struct SearchInfo: Codable {
    let textSnippet: String?
}
