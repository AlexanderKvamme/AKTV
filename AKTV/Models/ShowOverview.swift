//
//  ShowOverview.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation


struct ShowOverview: Codable {
//    var productionCompanies: ProductionCompany
    var status: String
//    var genres: [Genre]
    var numberOfSeasons: Int
//    var networks: [Network]
//    var popularity: Double
    var voteAverage: Double
//    var homepage: String
//    var originalName: String
//    var voteCount: Int
    var backdropPath: String?
//    var originalLanguage: String
    var name: String
//    var numberOfEpisodes: Int
//    var firstAirDate: Date
    var nextEpisodeToAir: Episode?
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

// MARK: - Mocks

extension ShowOverview {

    static var mock: ShowOverview {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = json.data(using: .utf8)
        let mockShowOverview = try! decoder.decode(ShowOverview.self, from: data!)
        return mockShowOverview
    }

    private static let json = #"""
    {
      "backdrop_path": "/vLPu0bjWSAAJ90imi7Hv2ItgwYu.jpg",
      "created_by": [
        {
          "id": 1242945,
          "credit_id": "5db08cf2bfeb8b00111df92f",
          "name": "Pendleton Ward",
          "gender": 2,
          "profile_path": "/soODVh1CrVo6YnfnLwpSyBxSm5z.jpg"
        },
        {
          "id": 2223981,
          "credit_id": "5f0b471b55bc350033293e32",
          "name": "Miki Brewster",
          "gender": 0,
          "profile_path": null
        }
      ],
      "episode_run_time": [
        45
      ],
      "first_air_date": "2020-06-25",
      "genres": [
        {
          "id": 10751,
          "name": "Family"
        },
        {
          "id": 16,
          "name": "Animation"
        },
        {
          "id": 35,
          "name": "Comedy"
        },
        {
          "id": 10765,
          "name": "Sci-Fi & Fantasy"
        }
      ],
      "homepage": "https://play.hbomax.com/series/urn:hbo:series:GXuu7ygQ61cI9DgEAAAAY",
      "id": 94810,
      "in_production": true,
      "languages": [
        "en",
        "ru",
        "es"
      ],
      "last_air_date": "2020-11-19",
      "last_episode_to_air": {
        "air_date": "2020-11-19",
        "episode_number": 2,
        "id": 1961673,
        "name": "Obsidian",
        "overview": "Marceline and Princess Bubblegum journey to the imposing, beautiful Glass Kingdom — and deep into their tumultuous past — to prevent an earthshaking catastrophe.",
        "production_code": "",
        "season_number": 1,
        "still_path": "/yHDZ48QJGFVh7zZKh46VEhu9qlJ.jpg",
        "vote_average": 0,
        "vote_count": 0
      },
      "name": "Adventure Time: Distant Lands",
      "next_episode_to_air": {
        "air_date": "2021-12-31",
        "episode_number": 4,
        "id": 1961677,
        "name": "Together Again",
        "overview": "Finn and Jake are reunited to rediscover their brotherly bond and embark on the most important adventure of their lives.",
        "production_code": "",
        "season_number": 1,
        "still_path": null,
        "vote_average": 0,
        "vote_count": 0
      },
      "networks": [
        {
          "name": "HBO Max",
          "id": 3186,
          "logo_path": "/nmU0UMDJB3dRRQSTUqawzF2Od1a.png",
          "origin_country": "US"
        }
      ],
      "number_of_episodes": 4,
      "number_of_seasons": 1,
      "origin_country": [
        "US"
      ],
      "original_language": "en",
      "original_name": "Adventure Time: Distant Lands",
      "overview": "Finn and Jake are headed back to the Land of Ooo.",
      "popularity": 34.373,
      "poster_path": "/9Q2ndDYqfNPleI1p5LDmqeD4WCs.jpg",
      "production_companies": [
        {
          "id": 7899,
          "logo_path": "/qnhd98hnBxCMMMod58FJqbCZ5O7.png",
          "name": "Cartoon Network Studios",
          "origin_country": "US"
        },
        {
          "id": 34764,
          "logo_path": "/bvon5U0QrVapPuHLopQLfK8O8rc.png",
          "name": "Frederator Studios",
          "origin_country": "US"
        }
      ],
      "production_countries": [
        {
          "iso_3166_1": "US",
          "name": "United States of America"
        }
      ],
      "seasons": [
        {
          "air_date": "2020-06-25",
          "episode_count": 4,
          "id": 134607,
          "name": "Season 1",
          "overview": "BMO is traveling through space on a mission to terraform Mars when he meets a small eyeball like robot, whom BMO dubs Olive. The mysterious robot suddenly transports BMO's ship into a distant part of space, which contains an ailing space station called The Drift. BMO encounters a young rabbit girl named Y5 (voiced by Glory Curda), who is a scavenger. Y5 plans to take BMO and have him sold for parts so as to impress her disapproving parents (voiced by Tom Kenny and Michelle Wong). Hugo (voiced by Randall Park), the leader of The Drift, cannot find anything useful from BMO, but needs a crystal from one of the jungle pods on The Drift so as to power a ship that will allow the Drift's residents to escape the station. BMO is hurt when he learns what Y5's plan was and ventures into the jungle pod by himself. However, BMO is betrayed by Hugo's assistant Mr. M (voiced by Stephen Root) and is left to die in the pod.",
          "poster_path": "/9Q2ndDYqfNPleI1p5LDmqeD4WCs.jpg",
          "season_number": 1
        }
      ],
      "spoken_languages": [
        {
          "english_name": "English",
          "iso_639_1": "en",
          "name": "English"
        },
        {
          "english_name": "Russian",
          "iso_639_1": "ru",
          "name": "Pусский"
        },
        {
          "english_name": "Spanish",
          "iso_639_1": "es",
          "name": "Español"
        }
      ],
      "status": "Returning Series",
      "tagline": "",
      "type": "Miniseries",
      "vote_average": 8,
      "vote_count": 159
    }
    """#
}

