//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Sajan Kushwaha on 2/5/26.
//


import XCTest

final class WeatherUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func test_tapSearch_opensSearchScreen() {
        let app = XCUIApplication()

        let searchBar = app.otherElements["search_button"]

        XCTAssertTrue(searchBar.waitForExistence(timeout: 3))
        XCTAssertTrue(searchBar.isHittable)

        searchBar.tap()

        let searchField = app.textFields["search_city_textfield"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
    }
}
