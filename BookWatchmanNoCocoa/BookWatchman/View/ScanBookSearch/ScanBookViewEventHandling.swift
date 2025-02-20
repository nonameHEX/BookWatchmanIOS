//
//  ScanBookViewEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 27.12.2024.
//

protocol ScanBookViewEventHandling: AnyObject {
    func handle(event: ScanBookViewModel.Event)
}
