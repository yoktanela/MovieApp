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
    var people = BehaviorRelay<[Person]>(value: [])
    var media = BehaviorRelay<[Media]>(value: [])

    override init() {
        super.init()
        apiService = APIService()
        callFunctionToGetMovieData()
        
        self.movies.subscribe(onNext: { movieList in
            movieList.forEach { movie in
                self.media.add(element: Media.movie(movie))
            }
        })
        
        self.people.subscribe(onNext: { personList in
            personList.forEach { person in
                self.media.add(element: Media.person(person))
            }
        })
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
                var mediaList: [Media] = []
                movieList.forEach { movie in
                    mediaList.append(Media.movie(movie))
                }
                personList.forEach { person in
                    mediaList.append(Media.person(person))
                }
                self?.media.accept(mediaList)
            })
    }
    
    func clearSearchResults() {
    }
}
