//
//  SearchOnlineViewModelTests.swift
//  BookWatchmanTests
//
//  Created by Tomáš Kudera on 13.01.2025.
//

import XCTest
import Combine

@testable import BookWatchman

final class SearchOnlineViewModelTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        cancellables = Set<AnyCancellable>()
    }
    
    func test_searchBooksSuccess() async throws {
        let expectation = XCTestExpectation(description: "Search books API call completes")

        // Vytvoření mock odpovědi
        let mockBookResponse = BookResponse(
            kind: "books#volumes",
            totalItems: 1,
            items: [
                BookItem(
                    kind: "books#volume",
                    id: "testId",
                    etag: "etag123",
                    selfLink: "https://www.googleapis.com/books/v1/volumes/testId",
                    volumeInfo: VolumeInfo(
                        title: "Test Book",
                        authors: ["Author Name"],
                        publisher: "Test Publisher",
                        publishedDate: "2025-01-01",
                        description: "Test description of the book.",
                        industryIdentifiers: nil,
                        readingModes: nil,
                        pageCount: 300,
                        printedPageCount: nil,
                        printType: "BOOK",
                        categories: ["Fiction"],
                        maturityRating: "NOT_MATURE",
                        allowAnonLogging: true,
                        contentVersion: "1.0.0",
                        panelizationSummary: nil,
                        imageLinks: nil,
                        language: "en",
                        previewLink: nil,
                        infoLink: nil,
                        canonicalVolumeLink: nil
                    ),
                    saleInfo: SaleInfo(country: "US", saleability: "FOR_SALE", isEbook: true),
                    accessInfo: AccessInfo(country: "US", viewability: "PARTIAL", embeddable: true, publicDomain: false, textToSpeechPermission: "ALLOWED", epub: nil, pdf: nil, webReaderLink: nil, accessViewStatus: "FULL_PUBLIC_DOMAIN", quoteSharingAllowed: true),
                    searchInfo: SearchInfo(textSnippet: "Snippet text here")
                )
            ]
        )
        
        let apiManager = ApiManagerMock(toReturn: .success(mockBookResponse))
        let viewModel = SearchOnlineViewModel(apiManager: apiManager)

        viewModel.searchQuery = "Test"
        
        viewModel.$searchResults
            .filter { !$0.isEmpty }
            .sink { results in
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.volumeInfo.title, "Test Book")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.searchBooks()

        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func test_searchBooksError() async {
        let apiManager = ApiManagerMock(toReturn: .failure(APIError.parsingError))
        let viewModel = SearchOnlineViewModel(apiManager: apiManager)

        viewModel.searchQuery = "Test"

        await viewModel.searchBooks()
        
        XCTAssertTrue(viewModel.searchResults.isEmpty)
    }
}
