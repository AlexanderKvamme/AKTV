//
//  TVShowSeason.swift
//  AKTV
//
//  Created by Alexander Kvamme on 24/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

// NOTE: Navn kan være fiel
// TODO: Implement

struct ShowOverview: Codable {
//    var productionCompanies: ProductionCompany
    var status: String
//    var genres: [Genre]
    var numberOfSeasons: Int
//    var networks: [Network]
//    var popularity: Double
//    var voteAverage: Int
//    var homepage: String
//    var originalName: String
//    var voteCount: Int
//    var backdropPath: String
//    var originalLanguage: String
//    var name: String
//    var numberOfEpisodes: Int
//    var firstAirDate: Date
//    var nextEpisodeToAir: Date?
//    var type: String
    var seasons: [SeasonOverview]
//    var createdBy: [Creator? Person?]
    var id: Int
//    var lastAirDate: Date?
//    var episodeRunTime: Int
//    var posterPath: String
//    var overView: String
//    var originalCountry: [Country]?
}


// FIXME: Actually display this in a

struct SeasonOverview: Codable {
    var airDate: String?
    var episodeCount: Int
    var id: Int
    var name: String
    var overview: String?
    var posterPath: String
    var seasonNumber: Int
}

struct Season: Codable {
    var name: String
    var id: Int
    var seasonNumber: Int
    var episodes: [Episode]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case seasonNumber = "season_number"
        case id = "id"
        case episodes = "episodes"
    }
 }

struct Episode: Codable {
    var name: String
    var episodeNumber: Int
    var airDate: String
    var id: Int
    var overview: String
    var productionCode: String
    var seasonNumber: Int
    var showId: Int
    var stillPath: String
    var voteAverage: Double
    var voteCount: Int
//    var crew: [Crew]
//    var guestStar: [Star]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case episodeNumber = "episode_number"
        case airDate = "air_date"
        case id = "id"
        case seasonNumber = "season_number"
        case productionCode = "production_code"
        case stillPath = "still_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case showId = "show_id"
        case overview = "overview"
       }
}
