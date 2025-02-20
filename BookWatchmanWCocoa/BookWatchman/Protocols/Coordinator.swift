//
//  Coordinator.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import Foundation

protocol Coordinator: AnyObject {
    var container: DIContainer { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
}
