//
//  BaseError.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

class BaseError {
    
    var error: String
    var errorCode: String
    var description: String
   
    init(error:String, errorCode: String, description: String) {
        self.error = error
        self.description = description
        self.errorCode = errorCode
    }
}
