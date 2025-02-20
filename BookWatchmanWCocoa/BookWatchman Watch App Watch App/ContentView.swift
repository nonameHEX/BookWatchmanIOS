//
//  DashBoardView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connector: PhoneConnector
    @StateObject var dashboardVM: DashboardViewModel
    @StateObject var bookshelfVM: BookshelfViewModel

    var body: some View {
        TabView {
            // Dashboard obrazovka
            DashboardView(dashboardVM: dashboardVM, connector: connector)
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2")
                }

            // Seznam knih
            BooksListView(bookshelfVM: bookshelfVM, connector: connector)
                .tabItem {
                    Label("Books", systemImage: "books.vertical")
                }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Swiping mezi obrazovkami
    }
}
