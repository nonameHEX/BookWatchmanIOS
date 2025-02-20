//
//  BookshelfViewEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

protocol BookshelfViewEventHandling: AnyObject {
    func handle(event: BookshelfViewModel.Event)
}
