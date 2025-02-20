//
//  StatsChip.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 04.01.2025.
//

import SwiftUI

struct StatsChip: View {
    let icon: Image
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(Circle())
            
            Text(text)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(color.opacity(0.8))
                .cornerRadius(16)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
