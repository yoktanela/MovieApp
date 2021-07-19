//
//  MovieDBApiTests.swift
//  MovieAppTests
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import XCTest
@testable import MovieApp

class MovieDBApiTests: XCTestCase {
    
    func testGetMoviesWithExpectedResult() throws {
        var moviesResponse: [Movie]?
        let moviesExpectation = expectation(description: "movies")
        
        let apiService = APIService()
        apiService.getPopularMovies(completion: { success, message, movieData in
            moviesResponse = movieData
            moviesExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(moviesResponse)
        }
    }
}
