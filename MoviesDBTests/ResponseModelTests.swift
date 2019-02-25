//
//  ResponseModelTests.swift
//  MoviesDBTests
//
//  Created by Mohamed Oshiba on 2/25/19.
//

import XCTest
@testable import MoviesDB

class ResponseModelTests: XCTestCase {

    func testParsing() throws {
        let json: [String: Any] = ["id": 2, "title": "Meet the parents!", "poster_path": "imagePath", "release_date": "date", "overview": "That was one hell of a funny movie!"] as [String : Any]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let decoder = JSONDecoder()
        let movie = try decoder.decode(Movie.self, from: data)
        
        XCTAssertEqual(movie.title, "Meet the parents!")
        XCTAssertEqual(movie.id, 2)
        XCTAssertEqual(movie.overview, "That was one hell of a funny movie!")
    }

}
