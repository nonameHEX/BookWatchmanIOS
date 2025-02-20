//
//  BooksListWithMockDataView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct BooksListWithMockDataView: View {
    @State private var textFilter: String = "" // Lokální textový filtr

    // Mock data
    let books: [Book] = [
        Book(
            id: UUID(),
            title: "Harry Potter and the Sorcerer's Stone",
            author: "J.K. Rowling",
            pageCount: 320,
            bookState: .Reading,
            pagesRead: 120,
            genre: "Fantasy",
            bookDescription: "Harry Potter discovers he's a wizard on his 11th birthday and attends Hogwarts.",
            isbn: "9780439708180",
            image: nil
        ),
        Book(
            id: UUID(),
            title: "The Hobbit",
            author: "J.R.R. Tolkien",
            pageCount: 300,
            bookState: .Read,
            pagesRead: 300,
            genre: "Fantasy",
            bookDescription: "A hobbit embarks on a dangerous journey to reclaim a lost treasure guarded by a dragon.",
            isbn: "9780618968633",
            image: nil
        ),
        Book(
            id: UUID(),
            title: "1984",
            author: "George Orwell",
            pageCount: 328,
            bookState: .ToBeRead,
            pagesRead: 0,
            genre: "Dystopian",
            bookDescription: "A chilling depiction of a totalitarian world under constant surveillance.",
            isbn: "9780451524935",
            image: nil
        )
    ]

    // Filtrované knihy
    var filteredBooks: [Book] {
        if textFilter.isEmpty {
            return books
        } else {
            return books.filter { $0.title.lowercased().contains(textFilter.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if filteredBooks.isEmpty {
                    // Prázdný seznam
                    VStack(spacing: 10) {
                        Text("List is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Vyhledávací pole
                    TextField("Vyhledat knihu v knihovně", text: $textFilter)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)

                    // Seznam knih
                    List(filteredBooks) { book in
                        NavigationLink(destination: BookDetailView(book: book)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(shortenedTitle(book.title))
                                        .font(.headline)
                                    if book.bookState == .Reading {
                                        Text("\(book.bookState.name): \(book.pagesRead)/\(book.pageCount)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text(book.bookState.name)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Books")
        }
    }

    // Zkrátí název knihy na max 12 znaků
    private func shortenedTitle(_ title: String) -> String {
        if title.count > 12 {
            return String(title.prefix(12)) + "…"
        } else {
            return title
        }
    }
}


struct BooksListWithMockDataView_Previews: PreviewProvider {
    static var previews: some View {
        BooksListWithMockDataView()
    }
}

