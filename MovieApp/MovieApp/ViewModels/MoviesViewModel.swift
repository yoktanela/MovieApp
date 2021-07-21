//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation

class MoviesViewModel: NSObject {
    
    // api service
    private var apiService: APIService!
    private(set) var movies : [Movie]! {
        didSet {
            self.bindMoviesViewModelToController()
        }
    }
    
    private(set) var moviesSearchResult : [Movie]? {
        didSet {
            self.bindMoviesSearchResultsViewModelToController()
        }
    }
    
    private(set) var peopleSearchResult : [Person]? {
        didSet {
            self.bindPeopleSearchResultsViewModelToController()
        }
    }
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    var bindMoviesSearchResultsViewModelToController : (() -> ()) = {}
    var bindPeopleSearchResultsViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        movies = []
        apiService = APIService()
        callFunctionToGetMovieData()
    }
    
    func callFunctionToGetMovieData(page: Int = 1) {
        apiService.getPopularMovies(page: page) { [weak self] success, message, list in
            self?.movies.append(contentsOf: list ?? [])
        }
    }
    
    func callFuntionToGetSearchResults(searchText: String) {
        apiService.getSearchResults(searchText: searchText) { [weak self] success, message, movieList, personList in
            self?.moviesSearchResult = movieList
            self?.peopleSearchResult = personList
        }
    }
}
