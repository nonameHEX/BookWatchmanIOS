//
//  BookItemCard.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.01.2025.
//

import SwiftUI

struct BookItemCard: View {
    let book: BookItem

    var body: some View {
        HStack {
            if let imageUrl = book.volumeInfo.imageLinks?.thumbnail, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 80, height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 120)
                    case .failure:
                        Text("Chyba při načítání obrázku")
                            .foregroundColor(.red)
                            .frame(width: 80, height: 120)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Text("Obrázek není k dispozici")
                    .frame(width: 80, height: 120)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            VStack(alignment: .leading) {
                Text(book.volumeInfo.title)
                    .font(.headline)
                Text(book.volumeInfo.authors?.joined(separator: ", ") ?? "Neznámý autor")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(book.volumeInfo.pageCount ?? 0) stran")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}
