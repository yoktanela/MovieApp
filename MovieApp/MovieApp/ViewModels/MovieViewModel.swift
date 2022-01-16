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
    
    private(set) var bag = DisposeBag()
    var originalTitle = BehaviorRelay<String>(value: "")
    var backdropPath = BehaviorRelay<String>(value: "")
    var overview = BehaviorRelay<String>(value: "")
    let voteAverage = BehaviorRelay<Double>(value: 0.0)
    let videos = BehaviorRelay<[Video]>(value: [])
    let cast = BehaviorRelay<[CastMember]>(value: [])
    
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
                guard let self = self else { return }
                self.originalTitle.accept(movie.originalTitle ?? "")
                self.backdropPath.accept(movie.backdropPath ?? "")
                self.overview.accept(movie.overview ?? "")
                self.voteAverage.accept(movie.voteAverage)
            })
            .disposed(by: bag)
    }
    
    func callFunctionToGetVideos(id: Int) {
        apiService.getVideos(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe( onNext: {[weak self] videoResult in
                guard let self = self else { return }
                self.videos.accept(videoResult.results)
            })
            .disposed(by: bag)
    }
    
    func callFunctionToGetCast(id: Int) {
        apiService.getCast(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cast in
                guard let self = self else { return }
                self.cast.accept(cast.cast)
            })
            .disposed(by: bag)
    }
}
