//
//  BookshelfView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

import SwiftUI

struct BookshelfView: View {
    // TODO změnit fungování syncu tak aby se vždy syncul celý list, momentálně to funguej tak, že se vždy přidá kniha na kterou si klikne
    @StateObject var bookshelfVM: BookshelfViewModel
    @StateObject var connector: WatchConnector
    
    @State var isChooseAddOptionsASPresented = false
    
    @State var textFilter: String = ""
    
    var body: some View {
        VStack {
            TextField("Vyhledat knihu v knihovně", text: $textFilter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .ClearButton(text: $textFilter)
            
            List(bookshelfVM.state.books) { book in
                HStack {
                    VStack {
                        if let bookImage = book.image {
                            Image(uiImage: bookImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 80)
                        } else {
                            Image(systemName: "books.vertical")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 80)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        if book.bookState == BookState.Reading {
                            Text("\(book.bookState.name) na \(book.pagesRead)")
                                .font(.subheadline)
                        }else{
                            Text(book.bookState.name)
                                .font(.subheadline)
                        }
                        
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    bookshelfVM.send(.didTapBook(book))
                }
                .swipeActions {
                    Button(role: .destructive) {
                        bookshelfVM.send(.didTapDeleteBook(book))
                        connector.sendDeleteRequestOnBookId(id: book.id)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
        .navigationTitle("Knihovna")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isChooseAddOptionsASPresented.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                })
                .accessibilityIdentifier("add-book-button")
            }
        }
        .actionSheet(isPresented: $isChooseAddOptionsASPresented) {
            ActionSheet(
                title: Text("Přidat knihu"),
                message: Text("Vyberte jak chcete přidat novou knihu do knihovny"),
                buttons: [
                    .default(Text("Vyhledat online")){
                        bookshelfVM.send(.didTapAddNewBookSearchOnline)
                    },
                    .default(Text("Sken knihy - online")){
                        bookshelfVM.send(.didTapAddNewBookScanBookOnline)
                    },
                    .default(Text("Přidat manuálně")){
                        bookshelfVM.send(.didTapAddNewBookManual)
                    },
                    .cancel(),
                ]
            )
        }
        .onAppear(){
            bookshelfVM.send(.didAppear)
        }
    }
}

#Preview {
    BookshelfView(
        bookshelfVM: BookshelfViewModel(
            bookService: MockCoreDataService()
        ),
        connector: WatchConnector(
            viewModel: BookshelfViewModel(bookService: MockCoreDataService()),
            bookService: MockCoreDataService())
    )
}
