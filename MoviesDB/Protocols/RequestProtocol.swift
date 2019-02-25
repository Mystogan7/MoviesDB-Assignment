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
    var httpMethod: HttpMethod { get }
    var responseModel: BaseModel.Type { get }
    var completion: (Result<Model, Error>) -> Void { get }

}

