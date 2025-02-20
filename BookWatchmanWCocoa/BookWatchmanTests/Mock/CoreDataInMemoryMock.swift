//
//  CoreDataInMemoryMock.swift
//  BookWatchmanTests
//
//  Created by Tomáš Kudera on 13.01.2025.
//

import CoreData

@testable import BookWatchman

extension CoreDataService {
    convenience init() {
        let container = NSPersistentContainer(name: "BookWatchman")
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Could not load Core Data persistent stores. Error \(error), \(error.userInfo)")
            }
        }
        
        self.init(moc: container.viewContext)
    }
}
