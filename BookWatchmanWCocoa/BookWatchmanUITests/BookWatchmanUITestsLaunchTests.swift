//
//  BookWatchmanUITestsLaunchTests.swift
//  BookWatchmanUITests
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import XCTest

final class BookWatchmanUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

    }
}
