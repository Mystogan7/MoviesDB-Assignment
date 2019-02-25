//
//  AddMoviesViewControllerTests.swift
//  MoviesDBTests
//
//  Created by Mohamed Oshiba on 2/25/19.
//

import XCTest
@testable import MoviesDB

class AddMoviesViewControllerTests: XCTestCase {

    var viewController: AddNewMoviesViewController!
    var didPickImage = false

    
    override func setUp() {
        viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(
            withIdentifier: "AddNewMoviesViewController") as? AddNewMoviesViewController
    }

    override func tearDown() {
        viewController = nil
    }

    func testPosterTapGestureExistance() {
        viewController.loadViewIfNeeded()
        XCTAssertTrue(viewController.posterImageView.gestureRecognizers?.first != nil, "Tap gesture doesn't exist.")
    }
    
    func testSaveButtonDisability() {
        viewController.loadViewIfNeeded()
        XCTAssertTrue(!(viewController.navigationItem.rightBarButtonItem?.isEnabled)!, "Save button shouldn't be enabled at first scene!")
    }
    
}
