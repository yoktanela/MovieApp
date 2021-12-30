//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation
import RxSwift
import RxCocoa

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
        apiService.getPopularMovies(page: page)
            .subscribe(onNext: { [weak self] movieList in
            self?.movies.append(contentsOf: movieList)
        })
    }
    
    func callFuntionToGetSearchResults(searchText: String) {
        apiService.getSearchResults(searchText: searchText)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieList, personList in
                self?.moviesSearchResult = movieList
                self?.peopleSearchResult = personList
            })
    }
    
    func clearSearchResults() {
        self.moviesSearchResult = nil
        self.peopleSearchResult = nil
    }
}
