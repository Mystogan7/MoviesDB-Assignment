//
//  FetchMoviesService.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//


import Foundation

class FetchMoviesService: BaseService<Movies, BaseError> {
    
    override func startBusinessLogic(parameters: Parameters, completion: @escaping (Result<Movies, BaseError>) -> Void) {
        let page = parameters["page"]
        let requiredModel = Movies.self
        let request = BaseRequest(path: Urls.Path.movies(page: page ?? ""), httpMethod: .get, requiredResponseModel: requiredModel) { (result) in
            let serviceResult: Result<Movies, BaseError>
            switch result {
            case .success(let model):
                serviceResult = .success(model)
            case .failure(let error):
                serviceResult = .failure(error)
            }
            completion(serviceResult)
        }
        startRequest(request: request)
    }
    
}

