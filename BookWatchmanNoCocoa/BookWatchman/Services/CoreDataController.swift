//
//  CoreDataController.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "BookWatchman")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Datafailed to create container: \(error.localizedDescription)")
            }
        }
    }
}
