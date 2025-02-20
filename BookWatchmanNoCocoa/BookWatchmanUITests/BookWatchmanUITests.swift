//
//  BookWatchmanUITests.swift
//  BookWatchmanUITests
//
//  Created by Tomáš Kudera on 02.12.2024.
//

import XCTest

final class BookWatchmanUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func test_tabBarNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        let dashboardTab = app.tabBars.buttons["Dashboard"]
        XCTAssertTrue(dashboardTab.exists)
        
        dashboardTab.tap()
        
        let dashboardTitle = app.staticTexts["Dashboard"]
        XCTAssertTrue(dashboardTitle.exists)
        
        let bookshelfTab = app.tabBars.buttons["Knihovna"]
        bookshelfTab.tap()
        
        let bookshelfTitle = app.staticTexts["Knihovna"]
        XCTAssertTrue(bookshelfTitle.exists)
    }
    
    func test_clickAddBookButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let bookshelfTab = app.tabBars.buttons["Knihovna"]
        bookshelfTab.tap()
        
        let addBookButton = app.buttons["add-book-button"]
        XCTAssertTrue(addBookButton.exists)
        addBookButton.tap()
        
        let actionSheetTitle = app.staticTexts["Přidat knihu"]
        XCTAssertTrue(actionSheetTitle.exists)

        let actionSheetMessage = app.staticTexts["Vyberte jak chcete přidat novou knihu do knihovny"]
        XCTAssertTrue(actionSheetMessage.exists)

        let searchOnlineButton = app.buttons["Vyhledat online"]
        XCTAssertTrue(searchOnlineButton.exists)
        
        let scanBookButton = app.buttons["Sken knihy - online"]
        XCTAssertTrue(scanBookButton.exists)
        
        let addManualButton = app.buttons["Přidat manuálně"]
        XCTAssertTrue(addManualButton.exists)
    }
    
    func test_searchFieldExistsAndIsWriteable() throws {
        let app = XCUIApplication()
        app.launch()

        let bookshelfTab = app.tabBars.buttons["Knihovna"]
        bookshelfTab.tap()

        let searchField = app.textFields["Vyhledat knihu v knihovně"]
        XCTAssertTrue(searchField.exists)

        searchField.tap()
        searchField.typeText("Test Potter")
        XCTAssertEqual(searchField.value as? String, "Test Potter")
    }
}
