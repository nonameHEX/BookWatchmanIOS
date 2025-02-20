//
//  DashBoardView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct BooksListView: View {
    @StateObject var bookshelfVM: BookshelfViewModel // ViewModel
    @State private var textFilter: String = ""      // Lokální textový filtr
    @StateObject var connector: PhoneConnector

    var filteredBooks: [Book] {
        if textFilter.isEmpty {
            return bookshelfVM.state.books
        } else {
            return bookshelfVM.state.books.filter { book in
                book.title.lowercased().contains(textFilter.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // TextField pro filtrování
                TextField("Vyhledat knihu v knihovně", text: $textFilter)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)

                // Obsah zobrazení
                if filteredBooks.isEmpty {
                    if textFilter.isEmpty {
                        // Žádné knihy v databázi
                        VStack(spacing: 10) {
                            Text("No books available")
                                .font(.headline)
                                .foregroundColor(.gray)

                            Button(action: {
                                bookshelfVM.send(.didRequestDataRefresh)
                            }) {
                                Text("Synchronizovat")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.borderless)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Žádné výsledky pro filtr
                        VStack(spacing: 10) {
                            Text("No matching books")
                                .font(.headline)
                                .foregroundColor(.gray)

                            Button(action: {
                                textFilter = "" // Vymazání filtru
                            }) {
                                Text("Clear filter")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.borderless)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    // Seznam knih
                    List(filteredBooks) { book in
                        NavigationLink(
                            destination: BookDetailView(
                                viewModel: BookDetailViewModel(
                                    bookService: bookshelfVM.bookService,
                                    book: book
                                ),
                                connector: connector
                            )
                        ) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(book.title)
                                        .font(.headline)
                                    if book.bookState == .Reading {
                                        Text("\(book.bookState.name): \(book.pagesRead)/\(book.pageCount)")
                                            .font(.subheadline)
                                            .foregroundColor(.orange)
                                    }else if book.bookState == .Read {
                                        Text(book.bookState.name)
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }else{
                                        Text(book.bookState.name)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
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
            .onAppear {
                bookshelfVM.send(.didAppear) // Načtení dat při zobrazení
            }
        }
    }
}
