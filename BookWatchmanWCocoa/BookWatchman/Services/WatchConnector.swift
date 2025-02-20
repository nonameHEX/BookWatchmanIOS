//
//  WatchConnector.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.01.2025.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchConnector: NSObject, WCSessionDelegate, ObservableObject {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {}
    
    private var session: WCSession
    private var viewModel: BookshelfViewModel
    private let bookService: CoreDataServicing
        
    init(session: WCSession = .default,
         viewModel: BookshelfViewModel,
         bookService: CoreDataServicing
    ) {
        self.session = session
        self.viewModel = viewModel
        self.bookService = bookService
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
    
    func sendAddRequest(item: Book) {
        if session.isReachable {
            var message: [String: Any] = ["action": "add"]
            message["book"] = item.toDictionary()
            
            let newSize = CGSize(width: 160, height: 160)
            if let resizedImage = item.image?.resize(to: newSize), let imageData = resizedImage.jpegData(compressionQuality: 0.3) {
                message["image"] = imageData
            }
            
            session.sendMessage(message, replyHandler: nil)
        } else {
            print("Session not reachable")
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
            print("phone: \(String(describing: textTest))")
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
            print("phone: update \(id) \(bookState) \(pagesRead)")
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
            print("phone: delete \(id)")
            DispatchQueue.main.async {
                self.bookService.deleteDbBookById(bookId: id)
                self.viewModel.send(.didRequestDataRefresh)
            }
        default:
            print("Unknown action: \(action)")
        }
    }

    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}

extension UIImage {
    // Function to resize the image (compatible with iOS 9+)
    func resize(to newSize: CGSize) -> UIImage? {
        // Begin a new image context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        // Draw the image in the context
        self.draw(in: CGRect(origin: .zero, size: newSize))

        // Capture the newly resized image
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the image context
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
