//
//  SearchOnlineViewEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

protocol SearchOnlineViewEventHandling: AnyObject {
    func handle(event: SearchOnlineViewModel.Event)
}
