//
//  Library.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 03.12.2024.
//

import Foundation
import MapKit

// MapItem = Library or bookstore
struct MapItem: Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var coords: CLLocationCoordinate2D
    var libraryUrl: URL?
    var distance: Double
}
