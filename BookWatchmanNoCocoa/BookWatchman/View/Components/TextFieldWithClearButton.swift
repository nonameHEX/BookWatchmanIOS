//
//  TextFieldWithClearButton.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 11.12.2024.
//

import SwiftUI


// TODO UPRAVIT ABY VYPADALO DOBŘE
struct TextFieldWithClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .padding(.trailing, 30)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct MultilineTextFieldWithClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
                .padding(.trailing, 30)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.secondary)
                        .padding(.trailing, 8)
                        .padding(.top, 8)
                }
            }
        }
    }
}

extension View {
    func ClearButton(text: Binding<String>) -> some View {
        self.modifier(TextFieldWithClearButton(text: text))
    }

    func MultilineClearButton(text: Binding<String>) -> some View {
        self.modifier(MultilineTextFieldWithClearButton(text: text))
    }
}
