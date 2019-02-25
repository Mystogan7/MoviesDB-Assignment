//
//  CachingTests.swift
//  MoviesDBTests
//
//  Created by Mohammed Oshiba on 2/25/19.
//

import XCTest
@testable import MoviesDB

class CacheServiceTests: XCTestCase {
   
    let service = Caching()
    
    override func setUp() {
        super.setUp()
        try? service.clear()
    }
    
    func testClear() {
        let expectation = self.expectation(description: #function)
        let string = "Hello world"
        let data = string.data(using: .utf8)!
        
        service.save(data: data, key: "key", completion: {
            try? self.service.clear()
            self.service.load(key: "key", completion: {
                XCTAssertNil($0)
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1)
    }
    
    func testSave() {
        let expectation = self.expectation(description: #function)
        let string = "Hello world"
        let data = string.data(using: .utf8)!
        
        service.save(data: data, key: "key")
        service.load(key: "key", completion: {
            XCTAssertEqual($0, data)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 1)
    }
}
