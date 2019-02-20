//
//  Result.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

enum Result<ResponseModel, ErrorModel> {
    case success(BaseModel)
    case failure(BaseError)
}
