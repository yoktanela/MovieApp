//
//  PersonViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation

class PersonViewModel: NSObject {
    
    var profilePath: Box<String?> = Box(nil)
    var name: Box<String?> = Box(" ")
    var biography: Box<String?> = Box(" ")
    var movieCredits: Box<[Movie]?> = Box(nil)
    
    // api service
    private var apiService: APIService!
    
    init(personId: Int) {
        super.init()
        apiService = APIService()
        callFunctionToGetPerson(id: personId)
        callFunctionToGetMovieCredits(id: personId)
    }
    
    func callFunctionToGetPerson(id: Int) {
        apiService.getPerson(id: id, completion: { [weak self] success, message, person in
            self?.profilePath.value = person?.profilePath
            self?.name.value = person?.name
            self?.biography.value = person?.biography
        })
    }
    
    func callFunctionToGetMovieCredits(id: Int) {
        apiService.getMovieCredits(id: id, completion: { [weak self] success, message, movieCreditResponse in
            self?.movieCredits.value = movieCreditResponse?.cast
        })
    }
}

final class Box<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
    
  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  init(_ value: T) {
    self.value = value
  }
    
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
