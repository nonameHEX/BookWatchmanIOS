//
//  DashboardView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var dashboardVM: DashboardViewModel
    @StateObject var connector: WatchConnector
    
    var body: some View {
        VStack {
            PieChartView(data: [
                (label: BookState.ToBeRead.name, value: dashboardVM.state.booksToBeRead, color: BookState.ToBeRead.color),
                (label: BookState.Reading.name, value: dashboardVM.state.booksReading, color: BookState.Reading.color),
                (label: BookState.Read.name, value: dashboardVM.state.booksRead, color: BookState.Read.color)
            ])
            .frame(height: 150)
            .padding()
            
            StatsChip(
                icon: Image(systemName: "hourglass"),
                text: "\(BookState.ToBeRead.name): \(dashboardVM.state.booksToBeRead)",
                color: BookState.ToBeRead.color
            )
            StatsChip(
                icon: Image(systemName: "bookmark.fill"),
                text: "\(BookState.Reading.name): \(dashboardVM.state.booksReading)",
                color: BookState.Reading.color
            )
            StatsChip(
                icon: Image(systemName: "book.fill"),
                text: "\(BookState.Read.name): \(dashboardVM.state.booksRead)",
                color: BookState.Read.color
            )
            ReadingProgressBar(
                pagesRead: dashboardVM.state.pagesRead,
                totalPages: dashboardVM.state.totalPages,
                iconName: "book.pages.fill",
                title: "Přečteno stránek"
            )
            
            Spacer()
            // TODO zde bude mapa s knihovnami a knihkupectvím + moynost kliknout na POI a ziskat tak blizsi info
        }
        .navigationTitle("Dashboard")
        .onAppear(){
            dashboardVM.send(.didAppear)
        }
    }
}



#Preview {
    DashboardView(
        dashboardVM: DashboardViewModel(
            bookService: MockCoreDataService()
        ),
        connector: WatchConnector(
            viewModel: BookshelfViewModel(bookService: MockCoreDataService()),
            bookService: MockCoreDataService())
    )
}
