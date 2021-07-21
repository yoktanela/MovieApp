//
//  MovieDBApiTests.swift
//  MovieAppTests
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import XCTest
@testable import MovieApp

class MovieDBApiTests: XCTestCase {
    
    // MARK: Tests for getPopularMovies
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
    
    func testGetMoviesWithPageExceedError() throws {
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
    
    // MARK: Tests for getMovie
    func testGetMovieWithExpectedResult() throws {
        var movieResponse: Movie?
        let movieExpectation = expectation(description: "movie")
        
        let apiService = APIService()
        let movieId = 121
        apiService.getMovie(id: movieId, completion: { success, message, movieData in
            movieResponse = movieData
            movieExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(movieResponse)
        }
    }
    
    func testGetMovieWithErrorResult() throws {
        let movieExpectation = expectation(description: "movie")
        var errorResponse: String?
        
        let apiService = APIService()
        let movieId = 100000
        apiService.getMovie(id: movieId, completion: { success, message, movie in
            errorResponse = message
            movieExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    // MARK: Tests for getPerson
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
    
    // MARK: Tests for getSearchResults
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
    
    // MARK: Tests for getCast
    func testGetCastWithExpectedResult() throws {
        var cast: Cast?
        let castExpectation = expectation(description: "cast")
        
        let apiService = APIService()
        let movieId = 121
        apiService.getCast(id: movieId, completion: { success, message, result  in
            cast = result
            castExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(cast)
        }
    }
    
    func testGetCastWithErrorResult() throws {
        let castExpectation = expectation(description: "cast")
        var errorResponse: String?
        
        let apiService = APIService()
        let movieId = 100000
        apiService.getCast(id: movieId, completion: { success, message, result  in
            errorResponse = message
            castExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    // MARK: Tests for getVideos
    func testGetVideosWithExpectedResult() throws {
        var videoResult: VideoResult?
        let videoExpectation = expectation(description: "video")
        
        let apiService = APIService()
        let movieId = 121
        apiService.getVideos(id: movieId, completion: { success, message, result  in
            videoResult = result
            videoExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(videoResult)
        }
    }
    
    func testGetVideosWithErrorResult() throws {
        let videoExpectation = expectation(description: "video")
        var errorResponse: String?
        
        let apiService = APIService()
        let movieId = 100000
        apiService.getVideos(id: movieId, completion: { success, message, result  in
            errorResponse = message
            videoExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    // MARK: Tests for getMovieCredits
    func testGetMovieCreditsWithExpectedResult() throws {
        var movies: MovieCreditResponse?
        let moviesExpectation = expectation(description: "movie_credits")
        
        let apiService = APIService()
        let personId = 113
        apiService.getMovieCredits(id: personId, completion: { success, message, result  in
            movies = result
            moviesExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(movies)
        }
    }
    
    func testGetMovieCreditsWithErrorResult() throws {
        let moviesExpectation = expectation(description: "movie_credits")
        var errorResponse: String?
        
        let apiService = APIService()
        let personId = 1000000
        apiService.getMovieCredits(id: personId, completion: { success, message, result  in
            errorResponse = message
            moviesExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    // MARK: Tests for getGenres
    func testGetGenresWithExpectedResult() throws {
        var genres: Genres?
        let genresExpectation = expectation(description: "genres")
        
        let apiService = APIService()
        apiService.getGenres( completion: { success, message, result  in
            genres = result
            genresExpectation.fulfill()
        })
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(genres)
        }
    }
}
