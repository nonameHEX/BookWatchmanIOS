//
//  DashBoardView.swift
//  BookWatchman Watch App Watch App
//
//  Created by Erik Pientak on 20.01.2025.
//

import SwiftUI

struct PageTrackerView: View {
    @ObservedObject var viewModel: BookDetailViewModel // ViewModel pro práci s detailem knihy
    @StateObject var connector: PhoneConnector

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // Zobrazení následující stránky
                if viewModel.pagesReadValue < (viewModel.book?.pageCount ?? 0) {
                    Text("\(viewModel.pagesReadValue + 1)")
                        .font(.system(size: 50, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                }

                // Zobrazení aktuální stránky
                Text("\(viewModel.pagesReadValue)")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .scaleEffect(1.2)
                    .animation(.easeInOut, value: viewModel.pagesReadValue)

                // Zobrazení předchozí stránky
                if viewModel.pagesReadValue > 1 {
                    Text("\(viewModel.pagesReadValue - 1)")
                        .font(.system(size: 50, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    // Reakce na gesta posunutí
                    if value.translation.height < -30 {
                        incrementPage()
                    } else if value.translation.height > 30 {
                        decrementPage()
                    }
                    checkBookState()
                }
        )
        .gesture(
            LongPressGesture(minimumDuration: 1.0)
                .onEnded { _ in
                    setBookToReadOrToBeRead()
                    checkBookState()
                }
            )
        
    }

    private func incrementPage() {
        if viewModel.pagesReadValue < viewModel.book?.pageCount ?? 0 {
            viewModel.updatePagesRead(to: viewModel.pagesReadValue + 1)
        }
    }

    private func decrementPage() {
        if viewModel.pagesReadValue > 0 {
            viewModel.updatePagesRead(to: viewModel.pagesReadValue - 1)
        }
    }
    
    private func setBookToReadOrToBeRead() {
        if let maxPage = viewModel.book?.pageCount {
            if viewModel.pagesReadValue == maxPage {
                viewModel.updatePagesRead(to: 0)
            } else {
                viewModel.updatePagesRead(to: maxPage)
            }
        }
    }

    
    private func checkBookState(){
        if viewModel.pagesReadValue == 0{
            viewModel.updateBookState(to: BookState.ToBeRead)
        }
        
        else if viewModel.pagesReadValue == viewModel.book?.pageCount{
            viewModel.updateBookState(to: BookState.Read)
        }
        
        else{
            viewModel.updateBookState(to: BookState.Reading)
        }
        viewModel.saveBookUpdatedValues()
        sendBookUpdate() // Posíláme aktualizaci na mobil

    }

    private func sendBookUpdate() {
        guard let book = viewModel.book else { return }
        connector.sendUpdateRequest(item: book)
    }

}

