//
//  ScanBookView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import SwiftUI
import MLKitVision
import MLKitTextRecognition
import PhotosUI

struct ScanBookView: View {
    @StateObject var scanBookVM: ScanBookViewModel
    @State private var selectedImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Picker("Možnost hledání", selection: $scanBookVM.state.searchOption) {
                ForEach(SearchBarOption.allCases, id: \.self) { option in
                    Text(option.name).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if let imageData = selectedImageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedImageData = nil
                        selectedItem = nil
                        scanBookVM.send(.didTapPhoto)
                    }
            } else {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Vyberte obrázek", systemImage: "photo")
                        .font(.headline)
                        .padding(16)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let selectedItem,
                           let data = try? await selectedItem.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            if let imageData = selectedImageData,
                               let image = UIImage(data: imageData) {
                                recognizeText(from: image)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            if !scanBookVM.state.searchResults.isEmpty || selectedImageData == nil  {
                List(scanBookVM.state.searchResults, id: \.id) { book in
                    BookItemCard(book: book)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("Did tap book " + book.volumeInfo.title)
                            scanBookVM.state.selectedBook = book
                            scanBookVM.send(.didTapBook)
                        }
                }
                .listStyle(.plain)
            } else if scanBookVM.state.isLoading {
                SearchLoadingBar()
            } else if let errorMessage = scanBookVM.state.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .navigationTitle("Sken knihy - online")
    }
    
    func recognizeText(from image: UIImage) {
        // Convert the UIImage to VisionImage for MLKit
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        // Create an instance of the text recognizer
        let latinOptions = TextRecognizerOptions()
        let textRecognizer = TextRecognizer.textRecognizer(options: latinOptions)
        
        // Perform the text recognition task
        textRecognizer.process(visionImage) { result, error in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("No text found")
                return
            }
            
            print("MLKit result: \(result.text)")
            // Extract the recognized text and search
            scanBookVM.send(.didReadPhotoText(result.text))
        }
    }
}

#Preview {
    ScanBookView(scanBookVM: ScanBookViewModel(apiManager: APIManager()))
}
