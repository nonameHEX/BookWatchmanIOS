//
//  DashboardViewModelEventHandling.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

protocol DashboardViewEventHandling: AnyObject {
    func handle(event: DashboardViewModel.Event)
}
