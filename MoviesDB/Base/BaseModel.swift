//
//  BaseModel.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/19/19.
//

import Foundation

class BaseModel: NSObject, Codable {
    
    override init() { super.init() }

    required init(from decoder: Decoder) throws { }
    
}
