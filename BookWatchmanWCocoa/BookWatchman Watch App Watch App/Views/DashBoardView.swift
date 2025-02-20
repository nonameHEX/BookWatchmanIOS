//
//  DashBoardView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var dashboardVM: DashboardViewModel
    @StateObject var connector: PhoneConnector

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                DashboardRow(
                    title: "Knížky",
                    value: dashboardVM.state.books.count,
                    backgroundColor: Color.purple.opacity(0.2),
                    iconName: "book"
                )
                
                DashboardRow(
                    title: BookState.ToBeRead.name,
                    value: dashboardVM.state.booksToBeRead,
                    backgroundColor: Color.blue.opacity(0.2),
                    iconName: "hourglass"
                )
                
                DashboardRow(
                    title: BookState.Reading.name,
                    value: dashboardVM.state.booksReading,
                    backgroundColor: Color.orange.opacity(0.2),
                    iconName: "bookmark.fill"
                )
                
                DashboardRow(
                    title: BookState.Read.name,
                    value: dashboardVM.state.booksRead,
                    backgroundColor: Color.green.opacity(0.2),
                    iconName: "book.fill"
                )

                Spacer(minLength: 10)
            }
        }
        .navigationTitle("Dashboard")
        .onAppear{dashboardVM.send(.didAppear)}
    }
}

struct DashboardRow: View {
    let title: String
    let value: Int
    let backgroundColor: Color
    let iconName: String

    var body: some View {
        HStack {
            // Ikona
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()

            Spacer()

            VStack(alignment: .trailing) {
                Text(title)
                    .font(.headline)

                Text("\(value)")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

