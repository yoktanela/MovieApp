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
    private let disposeBag = DisposeBag()
    
    var movies = BehaviorRelay<[Movie]>(value: [])
    
    override init() {
        super.init()
        apiService = APIService()
        callFunctionToGetMovieData()
    }
    
    func callFunctionToGetMovieData(page: Int = 1) {
        apiService.getPopularMovies(page: page)
            .subscribe(onNext: { [weak self] movieList in
                guard let oldDatas = self?.movies.value else {
                    self?.movies.accept(movieList)
                    return
                }
                self?.movies.accept(oldDatas + movieList)
        })
    }
    
    func callFuntionToGetSearchResults(searchText: String) {
        apiService.getSearchResults(searchText: searchText)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieList, personList in
                self?.movies.accept(movieList)
            })
    }
    
    func clearSearchResults() {
    }
}
