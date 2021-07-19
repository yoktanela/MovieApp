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
    
    func testGetMoviesWithPageExceedError() {
        let apiService = APIService()
        let moviesExpectation = expectation(description: "movies")
        var errorResponse: String?
        
        apiService.getPopularMovies(page: 1000, completion: { success, message, movieData in
            errorResponse = message
            moviesExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetPersonWithExpectedResult() throws {
        var personResponse: Person?
        let personExpectation = expectation(description: "person")
        
        let apiService = APIService()
        let personId = 113
        apiService.getPerson(id: personId, completion: { success, message, movieData in
            personResponse = movieData
            personExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(personResponse)
        }
    }
    
    func testGetPersonWithErrorResult() throws {
        let personExpectation = expectation(description: "person")
        var errorResponse: String?
        
        let apiService = APIService()
        let personId = 1000000
        apiService.getPerson(id: personId, completion: { success, message, person in
            errorResponse = message
            personExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetSearchResultsWithExpectedResult() throws {
        var movies: [Movie]?
        var persons: [Person]?
        let searchExpectation = expectation(description: "search")
        
        let apiService = APIService()
        let searchText = "lotr"
        apiService.getSearchResults(searchText: searchText, completion: { success, message, movieList, personList  in
            movies = movieList
            persons = personList
            searchExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertTrue(movies != nil && persons != nil)
        }
    }
    
    func testGetSearchResultsWithTvResults() throws {
        var movies: [Movie]?
        var persons: [Person]?
        let searchExpectation = expectation(description: "search")
        
        let apiService = APIService()
        let searchText = "fargo"
        apiService.getSearchResults(searchText: searchText, completion: { success, message, movieList, personList  in
            movies = movieList
            persons = personList
            searchExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertTrue(movies != nil && persons != nil)
        }
    }
    
    func testGetSearchResultsWithErrorResult() throws {
        var movies: [Movie]?
        var persons: [Person]?
        let searchExpectation = expectation(description: "search")
        
        let apiService = APIService()
        let searchText = "asdmnks"
        apiService.getSearchResults(searchText: searchText, completion: { success, message, movieList, personList  in
            movies = movieList
            persons = personList
            searchExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertTrue(movies == nil && persons == nil)
        }
    }
}
