//
//  TVShowSeason.swift
//  AKTV
//
//  Created by Alexander Kvamme on 24/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation


struct SeasonOverview: Codable {
    var airDate: String?
    var episodeCount: Int
    var id: Int
    var name: String
    var overview: String?
    var posterPath: String?
    var seasonNumber: Int
}

struct Season: Codable {
    var id: Int
    var name: String
    var seasonNumber: Int
    var episodes: [Episode]
    var overview: String
    var posterPath: String?
 }

struct Episode: Codable {
    var name: String
    var episodeNumber: Int
    var airDate: String
    var id: Int
    var overview: String
//    var productionCode: String
    var seasonNumber: Int
//    var showId: Int
    var stillPath: String?
    var voteAverage: Double
//    var voteCount: Int
//    var crew: [Crew]
//    var guestStar: [Star] 
}
