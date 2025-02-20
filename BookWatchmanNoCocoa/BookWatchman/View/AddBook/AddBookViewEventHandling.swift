//
//  AddBookViewEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 27.12.2024.
//

protocol AddBookViewEventHandling: AnyObject {
    func handle(event: AddBookViewModel.Event)
}
