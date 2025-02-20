//
//  ManualAddViewModel.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import Foundation
import SwiftUI

class AddBookViewModel: ObservableObject {
    private weak var coordinator: AddBookViewEventHandling?
    private let bookService: CoreDataServicing
    private var bookItem: BookItem?
    private var connector: WatchConnector
    
    @Published var selectedImage: UIImage? = nil
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var pageCount: String = ""
    @Published var genre: String = ""
    @Published var isbn: String = ""
    @Published var description: String = ""
    
    @Published var isSaveButtonEnabled: Bool = false
    @Published var invalidFields: [String] = []
    
    @Published var toastMessage = ""
    
    init(coordinator: AddBookViewEventHandling? = nil,
         bookService: CoreDataServicing,
         bookItem: BookItem? = nil,
         connector: WatchConnector
    ) {
        self.coordinator = coordinator
        self.bookService = bookService
        self.bookItem = bookItem
        self.connector = connector
    }
    
    func validateFields() {
        var errors: [String] = []
        
        if title.isEmpty {
            errors.append("Název")
        }
        if author.isEmpty {
            errors.append("Autor")
        }
        if pageCount.isEmpty || Int(pageCount) == nil {
            errors.append("Počet stran")
        }
        
        invalidFields = errors
        isSaveButtonEnabled = errors.isEmpty
        toastMessage = "Nejsou vyplněny všechny povinné údaje: \(invalidFields.joined(separator: ", "))"
    }
    
    
    @MainActor
    func setupInitialValues() {
        guard let bookItem = bookItem else { return }
        
        title = bookItem.volumeInfo.title
        author = bookItem.volumeInfo.authors?.first ?? ""
        pageCount = "\(bookItem.volumeInfo.pageCount ?? 0)"
        genre = bookItem.volumeInfo.categories?.first ?? ""
        isbn = bookItem.volumeInfo.industryIdentifiers?.first?.identifier ?? ""
        description = bookItem.volumeInfo.description ?? ""
        
        if let imageUrl = bookItem.volumeInfo.imageLinks?.thumbnail,
           let url = URL(string: imageUrl) {
            loadImage(from: url)
        }
    }
    
    func send(_ action: Action) {
        switch action {
        case .didTapSaveBook:
            if isSaveButtonEnabled == false {
                print("Nejsou vyplněny všechny povinné údaje.")
                return
            }
            
            let book = Book(
                title: title,
                author: author,
                pageCount: Int(pageCount) ?? 0,
                bookState: .ToBeRead,
                pagesRead: 0,
                genre: genre,
                bookDescription: description,
                isbn: isbn,
                image: selectedImage
            )
            
            bookService.addNewDbBook(book: book)
            
            connector.sendAddRequest(item: book)
            
            coordinator?.handle(event: .bookAdded)
        }
    }
    
    @MainActor
    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let image = UIImage(data: data) {
                    selectedImage = image
                } else {
                    print("Chyba při načítání obrázku z URL - neplatná data")
                }
            } catch {
                print("Chyba při načítání obrázku z URL: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: Event
extension AddBookViewModel {
    enum Event {
        case bookAdded
    }
}

// MARK: Action
extension AddBookViewModel {
    enum Action {
        case didTapSaveBook
    }
}
