//
//  BookDetailView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import SwiftUI

struct BookDetailView: View {
    enum Event {
        case close
    }
    weak var coordinator: BookDetailViewEventHandling?
    
    @StateObject var bookDetailVM: BookDetailViewModel
    var bookshelfVM: BookshelfViewModel
    @StateObject var connector: WatchConnector
    
    @Namespace var bookDetailNamespace
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        if let image = bookDetailVM.book?.image {
                            GeometryReader { geometry in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 550)
                                    .clipped()
                                    .offset(y: max(0, -geometry.frame(in: .global).minY))
                            }
                            .frame(height: 550)
                            .clipped()
                        }
                        bookTitleAndAuthor
                        bookDetails
                        bookDescription
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Detail")
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        coordinator?.handle(event: .close)
                    }) {
                        Text("Zavřít")
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    if(bookDetailVM.isEdited){
                        Button(action: {
                            bookDetailVM.saveBookUpdatedValues()
                            if let book = bookDetailVM.book {
                                connector.sendUpdateRequest(item: book)
                            }
                            bookshelfVM.send(.didRequestDataRefresh)
                            coordinator?.handle(event: .close)
                        }) {
                            Text("Uložit")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
    }
    
    
    /*
    var bookImageBanner: some View {
        VStack {
            if let image = bookDetailVM.book?.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } else {
                Color.gray
                    .frame(height: 250)
                    .overlay(Text("No Image Available").foregroundColor(.white))
            }
        }
    }
    */
    
    var bookTitleAndAuthor: some View {
        VStack(spacing: 4) {
            Text(bookDetailVM.book?.title ?? "")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Autor: " + (bookDetailVM.book?.author ?? ""))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .cardStyle()
    }
    
    
    var bookDetails: some View {
        VStack(spacing: 8) {
            Text("Celkem stránek: \(bookDetailVM.book?.pageCount ?? 0)")
            Picker("Stav knihy", selection: $bookDetailVM.selectedBookState) {
                ForEach(BookState.allCases, id: \.self) { state in
                    Text(state.name).tag(state)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: bookDetailVM.selectedBookState) { oldValue, newValue in
                bookDetailVM.updateBookState(to: newValue)
            }
            
            if bookDetailVM.selectedBookState == BookState.Reading {
                VStack {
                    Text("Zadejte stránku, na které jste skončili:")
                        .font(.subheadline)
                    
                    TextField("Stránka", text: Binding<String>(
                        get: {
                            bookDetailVM.pagesReadValue > 0 ? "\(bookDetailVM.pagesReadValue)" : ""
                        },
                        set: { newText in
                            let pattern = "^[0-9]*$"
                            if newText.isEmpty || newText.range(of: pattern, options: .regularExpression) != nil {
                                if let newCount = Int(newText), newCount <= (bookDetailVM.book?.pageCount ?? 0) {
                                    bookDetailVM.updatePagesRead(to: newCount)
                                } else if newText.isEmpty {
                                    bookDetailVM.updatePagesRead(to: 0)
                                }
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray))
                    
                    bookProgressBar
                }
                .padding(.top)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.3), value: bookDetailVM.selectedBookState == BookState.Reading)
            }
            if bookDetailVM.book?.genre != "" {
                Text("Žánr: \(bookDetailVM.book?.genre ?? "")")
            }
            
            if bookDetailVM.book?.isbn != "" {
                Text("ISBN: \(bookDetailVM.book?.isbn ?? "N/A")")
            }
            
        }
        .font(.body)
        .foregroundColor(.primary)
        .cardStyle()
    }
    
    
    var bookDescription: some View {
        VStack(spacing: 8) {
            Text("Popis")
                .font(.headline)
            Text(bookDetailVM.book?.bookDescription ?? "")
                .padding()
                .foregroundColor(.secondary)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .cardStyle()
    }
    
    var bookProgressBar: some View {
        VStack(alignment: .leading) {
            ProgressView(value: bookDetailVM.readingProgress)
            .progressViewStyle(LinearProgressViewStyle())
            .padding(.top)
            .tint(.blue)
            .animation(.smooth, value: bookDetailVM.readingProgress)
        }
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(.white).shadow(radius: 5))
            .padding(.horizontal)
    }
}

#Preview {
    BookDetailView(
        bookDetailVM: BookDetailViewModel(
            bookService: MockCoreDataService(),
            book: .mock
        ),
        bookshelfVM: BookshelfViewModel(bookService: MockCoreDataService()),
        connector: WatchConnector(
            viewModel: BookshelfViewModel(bookService: MockCoreDataService()),
            bookService: MockCoreDataService())
    )
}
