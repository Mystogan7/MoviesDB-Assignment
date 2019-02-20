//
//  RequestProtocol.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

protocol RequestProtocol {
    
    associatedtype Model: BaseModel
    associatedtype Error: BaseError

    var path: Urls.Path { get }
    var httpMethod: Urls.HttpMethod { get }
    var bodyParameters: [String: Any]? { get }
    var responseModel: BaseModel { get }
    var completion: (Result<Model, Error>) -> Void { get }

}

