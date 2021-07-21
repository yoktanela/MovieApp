//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation

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
        apiService.getMovie(id: id, completion: { [weak self] success, message, movie in
            self?.originalTitle.value = movie?.originalTitle
            self?.backdropPath.value = movie?.backdropPath
            self?.overview.value = movie?.overview
            self?.voteAverage.value = movie?.voteAverage
        })
    }
    
    func callFunctionToGetVideos(id: Int) {
        apiService.getVideos(id: id, completion: { [weak self] success, message, videoResult in
            self?.videos.value = videoResult?.results
        })
    }
    
    func callFunctionToGetCast(id: Int) {
        apiService.getCast(id: id, completion: { [weak self] success, message, cast in
            self?.cast.value = cast?.cast
        })
    }
}
