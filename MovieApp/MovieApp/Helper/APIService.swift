//
//  APIService.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation
import Alamofire

public class APIService: NSObject {
    
    override init() {
        super.init()
    }
    
    func getPopularMovies(page: Int = 1, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: [Movie]?) -> Void) {
        AF.request(Router.getPopularMovies(page: page, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                do {
                    let moviesData = try jsonDecoder.decode(MoviesResponse.self, from: data)
                    completion(true, nil, moviesData.results)
                } catch {
                    do {
                        let result = try jsonDecoder.decode(MoviesErrorResponse.self, from: data)
                        if result.errors.count > 0 {
                            completion(false, result.errors[0], nil)
                        } else {
                            //TODO: Localize error message
                            completion(false, "unknown error", nil)
                        }
                    } catch {
                        do {
                            let failResult = try jsonDecoder.decode(MoviesFailResponse.self, from: data)
                            completion(false, failResult.statusMessage, nil)
                        } catch {
                            //TODO: Localize error message
                            completion(false, "unknown error", nil)
                        }
                    }
                }
            case .failure(let error):
                completion(false, error.errorDescription, nil)
            }
        }
    }
}
