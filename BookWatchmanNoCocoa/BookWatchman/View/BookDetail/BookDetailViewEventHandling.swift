//
//  BookDetailViewEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

protocol BookDetailViewEventHandling: AnyObject {
    func handle(event: BookDetailView.Event)
}
