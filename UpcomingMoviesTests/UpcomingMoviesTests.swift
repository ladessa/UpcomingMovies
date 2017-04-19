//
//  UpcomingMoviesTests.swift
//  UpcomingMoviesTests
//
//  Created by Igor Ladessa on 18/04/17.
//  Copyright © 2017 Igor Ladessa. All rights reserved.
//

import XCTest
@testable import UpcomingMovies

class UpcomingMoviesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testGetMoviesWithAverageGreaterThan() {
        let average : Int = 5
        let page : Int = 1
                       
        MovieManager.getMoviesWithAverageGreaterThan(average: average, page: page, completion: { (listMovies : Array<Movie>?,totalPages, error) in
            XCTAssert(listMovies != nil && (listMovies?.count)! > 0)
            XCTAssertNil(error)
        })
        }

}
