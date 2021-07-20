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
    
    var bindMoviesViewModelToController : (() -> ()) = {}
    
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
}
