//
//  SearchOnlineView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import SwiftUI

struct SearchOnlineView: View {
    @StateObject var searchOnlineVM: SearchOnlineViewModel
    
    var body: some View {
        VStack {
            Picker("Možnost hledání", selection: $searchOnlineVM.searchOption) {
                ForEach(SearchBarOption.allCases, id: \.self) { option in
                    Text(option.name).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            TextField("Zadejte text", text: $searchOnlineVM.searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .ClearButton(text: $searchOnlineVM.searchQuery)
            
            Button("Vyhledat") {
                searchOnlineVM.searchBooks()
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                if searchOnlineVM.isLoading {
                    SearchLoadingBar()
                } else {
                    List(searchOnlineVM.searchResults, id: \.id) { book in
                        BookItemCard(book: book)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                print("Did tap book " + book.volumeInfo.title)
                                searchOnlineVM.selectedBook = book
                                searchOnlineVM.send(.didTapBook)
                            }
                    }
                    .listStyle(.plain)
                    
                    if let errorMessage = searchOnlineVM.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Vyhledat online")
    }
}

#Preview {
    SearchOnlineView(searchOnlineVM: SearchOnlineViewModel(apiManager: APIManager()))
}
