//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel: NSObject {
    
    var originalTitle: Box<String?> = Box(" ")
    var backdropPath: Box<String?> = Box(" ")
    var overview: Box<String?> = Box(" ")
    let voteAverage: Box<Double?> = Box(nil)
    let videos: Box<[Video]?> = Box(nil)
    let cast: Box<[CastMember]?> = Box(nil)
    
    // api service
    private var apiService: APIService!
    
    init(movieId: Int) {
        super.init()
        apiService = APIService()
        callFunctionToGetMovie(id: movieId)
        callFunctionToGetCast(id: movieId)
        callFunctionToGetVideos(id: movieId)
    }
    
    func callFunctionToGetMovie(id: Int) {
        apiService.getMovie(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe( onNext: {[weak self] movie in
                self?.originalTitle.value = movie.originalTitle
                self?.backdropPath.value = movie.backdropPath
                self?.overview.value = movie.overview
                self?.voteAverage.value = movie.voteAverage
            })
    }
    
    func callFunctionToGetVideos(id: Int) {
        apiService.getVideos(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe( onNext: {[weak self] videoResult in
                self?.videos.value = videoResult.results
            })
    }
    
    func callFunctionToGetCast(id: Int) {
        apiService.getCast(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cast in
                self?.cast.value = cast.cast
            })
    }
}
