//
//  Show.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

struct Show: Decodable, Hashable, Identifiable {
    var backdropPath: String?
    var firstAirDate: String?
    var genreIds: [Int]?
    var id: UInt64
    var name: String
    var originCountry: [String]?
    var originalLanguage: String?
    var originalName: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var voteAverage: Double?
    var voteCount: Int?
    var status: String?

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
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case status
    }
}

extension Show: MediaSearchResult {
    var subtitle: String {
        if let firstDash = firstAirDate?.firstIndex(of: "-") {
            return String(firstAirDate!.prefix(upTo: firstDash))
        }
        return ""
    }
}

extension Show {
    func getBackdropUrl() -> URL {
        guard
            let backdropPath = backdropPath,
            let url = URL(string: APIDAO.imdbImageRoot+backdropPath) else {
                return URL(string: "https://via.placeholder.com/150")!
            }

        return url

    }
}
