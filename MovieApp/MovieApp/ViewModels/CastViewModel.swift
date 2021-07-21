//
//  CastViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation

class CastViewModel: NSObject {
    
    // api service
    private var apiService: APIService!
    private(set) var cast : [CastMember]! {
        didSet {
            self.bindCastViewModelToController()
        }
    }
    
    var bindCastViewModelToController : (() -> ()) = {}
    
    init(movieId: Int) {
        super.init()
        cast = []
        apiService = APIService()
        callFunctionToGetCast(id: movieId)
    }
    
    func callFunctionToGetCast(id: Int) {
        apiService.getCast(id: id, completion: { [weak self] success, message, castResult in
            self?.cast = castResult?.cast
        })
    }
}
