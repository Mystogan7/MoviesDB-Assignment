//
//  BaseModel.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

class BaseModel: NSObject {
    
    //MARK: Initalization
    
    override init() {
    }
    
    required init?(json: JSON) {
        debugPrint("Initializing empty response object")
    }
    
}
