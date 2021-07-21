//
//  VideoViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation

class VideoViewModel: NSObject {
    
    // api service
    private var apiService: APIService!
    private(set) var videos : [Video]! {
        didSet {
            self.bindVideoViewModelToController()
        }
    }
    
    var bindVideoViewModelToController : (() -> ()) = {}
    
    init(movieId: Int) {
        super.init()
        videos = []
        apiService = APIService()
        callFunctionToGetVideos(id: movieId)
    }
    
    func callFunctionToGetVideos(id: Int) {
        apiService.getVideos(id: id, completion: { [weak self] success, message, videoResult in
            self?.videos = videoResult?.results
        })
    }
}
