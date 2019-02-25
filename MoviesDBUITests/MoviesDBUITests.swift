//
//  MoviesDBUITests.swift
//  MoviesDBUITests
//
//  Created by Mohamed Oshiba on 2/25/19.
//

import XCTest

class MoviesDBUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = true
        app = XCUIApplication()
        app.launch()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func testTableViewScrolling() {
        let tableView = app.tables.element(boundBy: 0)
        tableView.swipeUp()
        tableView.swipeUp()
    }
    
    func testGoToAddMovies() {
        let tablesQuery = app.tables
        tablesQuery.children(matching: .other).element(boundBy: 1).children(matching: .other).element.tap()
        tablesQuery.children(matching: .other)["header_0"].children(matching: .other)["header_0"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
    }
    
    func testBackButton() {
        app.tables.children(matching: .other)["header_0"].children(matching: .other)["header_0"].tap()
        app.navigationBars["MoviesDB.AddNewMoviesView"].buttons["Back"].tap()
    }
    
    func testTapImagePicker() {
         app.tables.children(matching: .other)["header_0"].children(matching: .other)["header_0"].tap()
         app.scrollViews.otherElements.images["poster-placeholder"].tap()
    }
    
}
