//
//  DashBoardView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    @State private var navigateToPageTracker = false
    @StateObject var connector: PhoneConnector

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Autor:")
                        .font(.title2)
                        .bold()

                    Text(viewModel.book?.author ?? "Neznámý autor")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Žánr:")
                        .font(.title2)
                        .bold()

                    Text(viewModel.book?.genre ?? "Neznámý žánr")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                NavigationLink(
                    destination: PageTrackerView(viewModel: viewModel,connector: connector),
                    isActive: $navigateToPageTracker
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stav:")
                            .font(.title2)
                            .bold()

                        if let book = viewModel.book {
                            switch book.bookState {
                            case .ToBeRead:
                                Text("K přečtení")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            case .Reading:
                                Text("Rozečteno (\(book.pagesRead)/\(book.pageCount) stran)")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                            case .Read:
                                Text("Přečteno")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding()
            .navigationTitle(viewModel.book?.title ?? "Detail knihy")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                viewModel.saveBookUpdatedValues()
            }
        }
    }
}


