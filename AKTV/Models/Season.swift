//
//  TVShowSeason.swift
//  AKTV
//
//  Created by Alexander Kvamme on 24/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation


struct SeasonOverview: Codable, Hashable {
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


extension Episode {
    func getFormattedDate() -> Date? {
        let formatter = DateFormatter.withoutTime
        return formatter.date(from: airDate)
    }
}

struct Episode: Codable, Hashable, Identifiable {
    var name: String
    var episodeNumber: Int
    var airDate: String
    var id: UInt64
    var overview: String
//    var productionCode: String
    var seasonNumber: Int
//    var showId: Int // Trokke denne finnes
    var stillPath: String?
    var voteAverage: Double
//    var voteCount: Int
//    var crew: [Crew]
//    var guestStar: [Star]

    // Customs
    var showId: Int?
    var artPath: String?

    static var mock: Episode {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = json.data(using: .utf8)
        let episode = try! decoder.decode(Episode.self, from: data!)
        return episode
    }

    static let json = #"""
    {
      "air_date": "2004-05-13",
      "episode_number": 24,
      "id": 249918,
      "name": "The mock episode",
      "overview": "Daphne gives birth to a healthy son, David.  Frasier marries Martin and Ronee in the vet's office before Daphne and the baby leave for the hospital.  Frasier grows very lonely with Martin out of the apartment and Daphne and Niles busy with their son.  He decides to take the San Francisco job.  Roz is named Kenny's replacement as station manager, and gives Noel a kiss during her celebration!  Frasier tells his family and Roz about his upcoming move, following a misunderstanding that leads them to believe he is dying.  He promises to visit frequently.  Frasier makes a speech to the group, and again on his final show at KACL, about the importance of taking chances.  His seatmate on the plane thanks him for the stimulating conversation as their plane finally lands...in Chicago.",
      "production_code": "",
      "season_number": 11,
      "still_path": "/9txvhNGhKcbRWWLItf4cUY8Sl0G.jpg",
      "vote_average": 0,
      "vote_count": 0
    }
    """#
}

