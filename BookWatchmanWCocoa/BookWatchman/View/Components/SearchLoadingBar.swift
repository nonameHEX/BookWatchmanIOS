//
//  SearchLoadingBar.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 27.12.2024.
//

import SwiftUI

struct SearchLoadingBar: View {
    @State private var offset: CGFloat = -UIScreen.main.bounds.width
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 8)
            
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width, height: 8)
                .offset(x: offset)
        }
        .padding(.horizontal)
        .onAppear {
            simulateProgress()
        }
    }
    
    private func simulateProgress() {
        offset = -UIScreen.main.bounds.width
        
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            offset = UIScreen.main.bounds.width
        }
    }
}
