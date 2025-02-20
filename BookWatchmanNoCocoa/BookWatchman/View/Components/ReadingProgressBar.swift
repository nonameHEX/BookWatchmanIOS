//
//  ReadingProgressBar.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.01.2025.
//

import SwiftUI

struct ReadingProgressBar: View {
    let pagesRead: Int
    let totalPages: Int
    let iconName: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title): \(pagesRead) / \(totalPages)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Image(systemName: iconName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
            .padding(.top)
            
            ProgressView(value: Double(pagesRead), total: Double(totalPages))
                .progressViewStyle(LinearProgressViewStyle(tint: BookState.Reading.color))
                .frame(height: 16)
                .background(LinearGradient(gradient: Gradient(colors: [BookState.Reading.color.opacity(0.4), BookState.Read.color.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
