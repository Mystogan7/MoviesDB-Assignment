//
//  ResponseModels.swift
//  MoviesDB
//
//  Created by Mohamed Oshiba on 2/20/19.
//

import Foundation

class Movies: BaseModel {
    var page: Int?
    var numberOfResults: Int?
    var numberOfPages: Int?
    var movies: [Movie]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MoviesCodingKeys.self)
        let superdecoder = try container.superDecoder()
        try super.init(from: superdecoder)
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
    }
}

extension Movies {
    private enum MoviesCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case movies = "results"
    }
}


class Movie: BaseModel {
    var id: Int?
    var posterPath: String?
    var title: String?
    var releaseDate: String?
    var overview: String?
    
    required init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        let superdecoder = try movieContainer.superDecoder()
        try super.init(from: superdecoder)
        id = try movieContainer.decode(Int.self, forKey: .id)
        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
        title = try movieContainer.decode(String.self, forKey: .title)
        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
        overview = try movieContainer.decode(String.self, forKey: .overview)
    }
}

extension Movie {
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
        case overview
    }
}
