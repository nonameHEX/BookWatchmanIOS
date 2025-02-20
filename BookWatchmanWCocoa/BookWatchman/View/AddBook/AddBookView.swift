//
//  ManualAddView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import SwiftUI
import PhotosUI

struct AddBookView: View {
    @StateObject var addBookVM: AddBookViewModel
    
    @State private var pickedPhoto: PhotosPickerItem?
    
    @State private var showContent = false
    @State private var showToast = false
    @State private var shakeSaveButton = false
    @State private var buttonColor: Color = .gray.opacity(0.7)
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView {
                VStack(spacing: 8) {
                    ZStack {
                        if let image = addBookVM.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 5)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                                .animation(.spring(), value: addBookVM.selectedImage)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 180, height: 220)
                                .overlay(
                                    Text("Vložte obrázek")
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                )
                                .shadow(radius: 3)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 1), value: addBookVM.selectedImage)
                        }
                    }
                    .animation(.easeInOut(duration: 1), value: addBookVM.selectedImage)
                    .onAppear {
                        showContent = true
                    }
                    
                    PhotosPicker("Vyberte fotku", selection: $pickedPhoto, matching: .images)
                        .onChange(of: pickedPhoto) {
                            Task {
                                if let data = try? await pickedPhoto?.loadTransferable(type: Data.self){
                                    if let image = UIImage(data: data){
                                        addBookVM.selectedImage = image
                                    }
                                }else{
                                    print("Error during photo selection")
                                }
                            }
                        }
                    
                    TextField("Název knihy", text: $addBookVM.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(addBookVM.invalidFields.contains("Název") ? Color.red : Color.gray, lineWidth: 1)
                        )
                        .onChange(of: addBookVM.title) {
                            addBookVM.validateFields()
                        }
                        .padding(.horizontal)
                    
                    TextField("Autor", text: $addBookVM.author)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(addBookVM.invalidFields.contains("Autor") ? Color.red : Color.gray, lineWidth: 1)
                        )
                        .onChange(of: addBookVM.author) {
                            addBookVM.validateFields()
                        }
                        .padding(.horizontal)
                    
                    TextField("Počet stran", text: $addBookVM.pageCount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(addBookVM.invalidFields.contains("Počet stran") ? Color.red : Color.gray, lineWidth: 1)
                        )
                        .onChange(of: addBookVM.pageCount) {
                            addBookVM.validateFields()
                        }
                        .padding(.horizontal)
                    
                    TextField("Žánr", text: $addBookVM.genre)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    TextField("ISBN", text: $addBookVM.isbn)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    TextField("Popis", text: $addBookVM.description, axis: .vertical)
                        .lineLimit(8...8)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    Button(action: {
                        if addBookVM.isSaveButtonEnabled {
                            addBookVM.send(.didTapSaveBook)
                        } else {
                            showToast = true
                            shakeSaveButton = true
                            buttonColor = .red
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                shakeSaveButton = false
                                buttonColor = .gray.opacity(0.7)
                            }
                        }
                    }) {
                        Text("Uložit")
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(buttonColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(radius: addBookVM.isSaveButtonEnabled ? 5 : 0)
                            .opacity(addBookVM.isSaveButtonEnabled ? 1 : 0.8)
                    }
                    .padding(.horizontal)
                    .offset(x: shakeSaveButton ? -10 : 0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.2), value: shakeSaveButton)
                    .animation(.easeInOut(duration: 0.5), value: buttonColor)
                    .onAppear {
                        buttonColor = addBookVM.isSaveButtonEnabled ? .blue : .gray.opacity(0.7)
                    }
                    .onChange(of: addBookVM.isSaveButtonEnabled) {
                        buttonColor = addBookVM.isSaveButtonEnabled ? .blue : .gray.opacity(0.7)
                    }
                }
                .padding()
            }
            
            if showToast {
                HStack {
                    Text(addBookVM.toastMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }
                .transition(.move(edge: .top))
                .zIndex(1)
                .offset(y: showToast ? 0 : -100)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showToast = false
                        }
                    }
                }
            }
        }
        .navigationTitle("Přidat knihu")
        .onAppear {
            addBookVM.setupInitialValues()
            addBookVM.validateFields()
        }
    }
    
    struct CustomTextField: View {
        var placeholder: String
        @Binding var text: String
        var keyboardType: UIKeyboardType = .default

        var body: some View {
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                )
                .shadow(radius: 2)
                .padding(.horizontal)
        }
    }
}

#Preview {
    AddBookView(addBookVM: AddBookViewModel(bookService: MockCoreDataService(), connector: WatchConnector(viewModel: BookshelfViewModel(bookService: MockCoreDataService()), bookService: MockCoreDataService())))
}
