//
//  PersonViewModel.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 21.07.2021.
//

import Foundation
import RxSwift
import RxCocoa

class PersonViewModel: NSObject {
    
    private(set) var bag = DisposeBag()
    var profilePath = BehaviorRelay<String>(value: "")
    var name = BehaviorRelay<String>(value: "")
    var biography = BehaviorRelay<String>(value: "")
    var movieCredits = BehaviorRelay<[Movie]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    // api service
    private var apiService: APIService!
    
    init(personId: Int) {
        super.init()
        apiService = APIService()
        callFunctionToGetPerson(id: personId)
        callFunctionToGetMovieCredits(id: personId)
    }
    
    func callFunctionToGetPerson(id: Int) {
        isLoading.accept(true)
        apiService.getPerson(id: id)
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.isLoading.accept(false) })
            .subscribe(onNext: { [weak self] person in
                guard let self = self else { return }
                self.profilePath.accept(person.profilePath ?? "")
                self.name.accept(person.name ?? "")
                self.biography.accept(person.biography ?? "")
            })
            .disposed(by: bag)
    }
    
    func callFunctionToGetMovieCredits(id: Int) {
        apiService.getMovieCredits(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieCreditResponse in
                guard let self = self else { return }
                self.movieCredits.accept(movieCreditResponse.cast ?? [])
            })
            .disposed(by: bag)
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
