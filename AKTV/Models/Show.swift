//
//  Show.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

struct Show: Decodable {
    var backdropPath: String
    var firstAirDate: Date
    var genreIds: [Int]
    var id: Int
    var name: String
    var originCountry: [String]
    var originalLanguage: String
    var originalName: String
    var overview: String
    var popularity: String
    var posterPath: String
//    var voteAverage: String
//    var voteCount: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        
    //    case lastName = "user_last_name"
    //    case age
    }
}
