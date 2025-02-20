//
//  PhoneConnector.swift
//  BookWatchman Watch App Watch App
//
//  Created by Tomáš Kudera on 02.01.2025.
//

import Foundation
import WatchConnectivity
import SwiftUI

class PhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {}
    
    private var session: WCSession
    private let bookService: CoreDataServicing
    private var viewModel: BookshelfViewModel
    
    init(session: WCSession = .default,
         bookService: CoreDataServicing,
         viewModel: BookshelfViewModel
    ) {
        self.session = session
        self.bookService = bookService
        self.viewModel = viewModel
        super.init()
        
        session.delegate = self
        session.activate()
    }
    
    func placeholderMessage(text: String) {
        if session.isReachable {
            let message: [String: Any] = [
                "action": "textTest",
                "textTest": text
            ]
            
            session.sendMessage(message, replyHandler: nil)
        }
    }
    
    func sendUpdateRequest(item: Book) {
        if session.isReachable {
            let message: [String: Any] = [
                "action": "update",
                "id": item.id.uuidString,
                "bookState": item.bookState.rawValue,
                "pagesRead": item.pagesRead
            ]
            
            session.sendMessage(message, replyHandler: nil)
        } else {
            print("Session not reachable")
        }
    }
    
    func sendDeleteRequestOnBookId(id: UUID) {
        if session.isReachable {
            let message: [String: Any] = [
                "action": "delete",
                "id": id.uuidString
            ]
            session.sendMessage(message, replyHandler: nil)
        } else {
            print("Session not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
            guard
                let action = message["action"] as? String
            else {
                print("Invalid message format")
                return
            }
            
        switch action {
        case "textTest":
            let textTest = message["textTest"] as? String
            print("watch: \(String(describing: textTest))")
        case "add":
            guard
                let bookDict = message["book"] as? [String: Any],
                let book = Book.fromDictionary(bookDict)
            else {
                print("Invalid update message format")
                return
            }
            print("watch: add \(book)")
            DispatchQueue.main.async {
                self.bookService.addNewDbBook(book: book)
                self.viewModel.send(.didRequestDataRefresh)
            }
        case "update":
            guard
                let idString = message["id"] as? String,
                let id = UUID(uuidString: idString),
                let bookStateRawValue = message["bookState"] as? Int16,
                let bookState = BookState(rawValue: bookStateRawValue),
                let pagesRead = message["pagesRead"] as? Int
            else {
                print("Invalid update message format")
                return
            }
            print("watch: update \(id) \(bookState) \(pagesRead)")
            DispatchQueue.main.async {
                self.bookService.updateDbBook(bookId: id, bookState: bookState, pagesRead: pagesRead)
                self.viewModel.send(.didRequestDataRefresh)
            }
        case "delete":
            guard
                let idString = message["id"] as? String,
                let id = UUID(uuidString: idString)
            else {
                print("Invalid delete message format")
                return
            }
            print("watch: delete \(id)")
            DispatchQueue.main.async {
                self.bookService.deleteDbBookById(bookId: id)
                self.viewModel.send(.didRequestDataRefresh)
            }
        default:
            print("Unknown action: \(action)")
        }
    }
}
