//
//  BaseRequest.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

class BaseRequest<ResponseModel: BaseModel, ErrorModel: BaseError>: RequestProtocol {
   
    typealias Model = ResponseModel
    typealias Error = ErrorModel
    
    var path: Urls.Path
    var httpMethod: Urls.HttpMethod
    var responseModel: BaseModel.Type
    var completion: (Result<Model, Error>) -> Void

    init(path: Urls.Path,
         httpMethod: Urls.HttpMethod = .get,
         requiredResponseModel: BaseModel.Type,
         resultHandler: @escaping (Result<Model, Error>) -> Void) {
        self.path = path
        self.httpMethod = httpMethod
        self.completion = resultHandler
        self.responseModel = requiredResponseModel
       
    }
}
