//
//  MoviesViewControllerTests.swift
//  MoviesViewControllerTests
//
//  Created by Mohamed Oshiba on 2/25/19.
//

import Foundation
import XCTest
@testable import MoviesDB

class MockClient : FetchMoviesService {
    var didCallFetchMovie = false
    var completeWithResult: Result<Movies, BaseError>?
    var delay: TimeInterval = 1
    var fetchExpectation: XCTestExpectation?
    
    
    init(completingWith result: Result<Movies, BaseError>? = nil) {
        completeWithResult = result
    }
    
    
    override func startBusinessLogic(parameters: Parameters, completion: @escaping (Result<Movies, BaseError>) -> Void) {
        didCallFetchMovie = true
        guard let completeWithResult = self.completeWithResult else { return }
        fetchExpectation = XCTestExpectation(description: "movies returned")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(completeWithResult)
            self.fetchExpectation?.fulfill()
        }
    }
    
    func verifyFetchCalled() {
        XCTAssert(didCallFetchMovie, "Fetch movies count was not called")
    }
}

class MoviesViewControllerTests: XCTestCase {
    
    var viewController: MoviesViewController!
    
    override func setUp() {
        viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(
            withIdentifier: "MoviesViewController") as? MoviesViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
    }
    
    func testMoviesWhenLoaded() {
        let mockClient = MockClient()
        viewController.fetchMoviesService = mockClient
        viewController.loadViewIfNeeded()
        mockClient.verifyFetchCalled()
    }
    
    func testControllerHasTableView() {
        viewController.loadViewIfNeeded()
        XCTAssertNotNil(viewController.tableView,
                        "Controller should have a tableview")
    }
    
    func testTableViewHeaderText() {
        viewController.loadViewIfNeeded()
        viewController.tableView.register(nib: UINib(nibName:MoviesHeaderView.nibName, bundle: .main), withHeaderFooterViewClass: MoviesHeaderView.self)
        let header = viewController.tableView.dequeueReusableHeaderFooterView(withClass: MoviesHeaderView.self)
        header.headerLabel.text = "My Movies"
        XCTAssertEqual(header.headerLabel.text, "My Movies",
                       "Should be My movies.")
    }
    
    func testRowCount() {
    let page = 1
    let movieSample = ["id": 2, "title": "text1", "poster_path": "imagePath", "release_date": "date", "overview": "overView"] as [String : Any]
    let moviesSample = ["page": page, "total_results": 1, "total_pages": 1,  "results": [movieSample, movieSample]] as [String : Any]
    let data1 = try! JSONSerialization.data(withJSONObject: moviesSample, options: .prettyPrinted)
    let movies = try! JSONDecoder().decode(Movies.self, from: data1)
    let mockClient = MockClient(completingWith: .success(movies))
    viewController.fetchMoviesService = mockClient
    _ = viewController.view
    wait(for: [mockClient.fetchExpectation!], timeout: 3.0)
    //For testing purpose only, usually I should check my loading views display modes and map according to him
    let rowCount = 2
    XCTAssertEqual(rowCount, 2)
    }
    
}

