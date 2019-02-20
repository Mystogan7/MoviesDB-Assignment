//
//  Networking.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

class BaseService<ServiceModel:BaseModel, ServiceError> {
    
    final func start(parameters: Parameters, completion: @escaping (Result<ServiceModel, ServiceError>)->Void) {
       startBusinessLogic(parameters: parameters, completion: completion)
    }
    
    final func startRequest<Request: RequestProtocol>(request: Request) {
        NetworkManager.shared.start(request)
    }
    
    func startBusinessLogic(parameters: Parameters, completion: @escaping (Result<ServiceModel, ServiceError>)->Void) {
        //Should be implemented and overriden.
    }
    
}

