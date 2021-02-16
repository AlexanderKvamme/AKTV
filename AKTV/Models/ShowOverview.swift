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
    var overview: String // overview?
//    var originalCountry: [Country]?
    var videos: Videos?
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
      "episode_run_time" : [
        60
      ],
      "status" : "Returning Series",
      "backdrop_path" : "\/7dnjFPoa22Yl3RKctp8kgUxiUg9.jpg",
      "overview" : "An ex-con becomes the traveling partner of a conman who turns out to be one of the older gods trying to recruit troops to battle the upstart deities. Based on Neil Gaiman's fantasy novel.",
      "in_production" : true,
      "vote_count" : 928,
      "tagline" : "",
      "last_air_date" : "2021-02-14",
      "original_name" : "American Gods",
      "networks" : [
        {
          "logo_path" : "\/8GJjw3HHsAJYwIWKIPBPfqMxlEa.png",
          "id" : 318,
          "origin_country" : "US",
          "name" : "Starz"
        }
      ],
      "first_air_date" : "2017-04-30",
      "number_of_episodes" : 26,
      "original_language" : "en",
      "origin_country" : [
        "US"
      ],
      "name" : "American Gods",
      "homepage" : "https:\/\/www.starz.com\/us\/en\/series\/31151",
      "poster_path" : "\/3KCAZaKHmoMIN9dHutqaMtubQqD.jpg",
      "production_countries" : [
        {
          "name" : "United States of America",
          "iso_3166_1" : "US"
        }
      ],
      "seasons" : [
        {
          "poster_path" : "\/fhqKjSw4JabcjGzjfE528nsIXDq.jpg",
          "id" : 126675,
          "season_number" : 0,
          "episode_count" : 1,
          "overview" : "Recap the biggest moment from season one. Pick your side before the war begins.",
          "air_date" : "2019-03-10",
          "name" : "Specials"
        },
        {
          "poster_path" : "\/rASj7OUjWDhfhAeO2MaFOA3lJpQ.jpg",
          "id" : 68626,
          "season_number" : 1,
          "episode_count" : 8,
          "overview" : "",
          "air_date" : "2017-04-30",
          "name" : "Season 1"
        },
        {
          "poster_path" : "\/4l8Vnbb7e5QA6bAItMqQIHXLRgc.jpg",
          "id" : 113970,
          "season_number" : 2,
          "episode_count" : 8,
          "overview" : "In Season 2, the battle moves towards crisis point. While Mr. World plots revenge, Shadow throws in his lot with Wednesday's attempt to convince the Old Gods of the case for full-out war, with Laura and Mad Sweeney in tow.",
          "air_date" : "2019-03-10",
          "name" : "Season 2"
        },
        {
          "poster_path" : "\/tZrBtmZANKKuCjgKMKXqOGzVNBD.jpg",
          "id" : 166922,
          "season_number" : 3,
          "episode_count" : 10,
          "overview" : "In Season 3 Shadow angrily pushes this apparent destiny away, and settles in the idyllic snowy town of Lakeside, Wisconsin — to make his own path, guided by the gods of his black ancestors, the Orishas. But he’ll soon discover that this town's still waters run deep, and dark, and bloody, and that you don’t get to simply reject being a god. The only choice — and a choice you have to make — is what kind of god you’re going to be.",
          "air_date" : "2021-01-10",
          "name" : "Season 3"
        }
      ],
      "id" : 46639,
      "next_episode_to_air" : {
        "production_code" : "",
        "id" : 2617094,
        "episode_number" : 6,
        "season_number" : 3,
        "still_path" : "\/xumxNai0t5724GEqPI3HQw2acXI.jpg",
        "vote_count" : 0,
        "vote_average" : 0,
        "overview" : "",
        "air_date" : "2021-02-21",
        "name" : "Conscience of The King"
      },
      "type" : "Scripted",
      "number_of_seasons" : 3,
      "last_episode_to_air" : {
        "production_code" : "",
        "id" : 2617091,
        "episode_number" : 5,
        "season_number" : 3,
        "still_path" : "\/em0Ux2gxNdfi01OskfO6NDcNp0U.jpg",
        "vote_count" : 1,
        "vote_average" : 8,
        "overview" : "Shadow explores notions of purpose, destiny and identity with a newly enlightened Bilquis. Elsewhere, Technical Boy struggles with an identity crisis of his own. Wednesday asks Shadow to assist in a new con.",
        "air_date" : "2021-02-14",
        "name" : "Sister Rising"
      },
      "popularity" : 344.64299999999997,
      "genres" : [
        {
          "id" : 18,
          "name" : "Drama"
        },
        {
          "id" : 9648,
          "name" : "Mystery"
        },
        {
          "id" : 10765,
          "name" : "Sci-Fi & Fantasy"
        }
      ],
      "created_by" : [
        {
          "gender" : 2,
          "id" : 191937,
          "credit_id" : "5588b8a3c3a3686acb000688",
          "name" : "Michael Green",
          "profile_path" : "\/oXmMv1vlJf2G9xWwCXBPrRY50EV.jpg"
        },
        {
          "gender" : 2,
          "id" : 17311,
          "credit_id" : "5588b903c3a3680545001ddd",
          "name" : "Bryan Fuller",
          "profile_path" : "\/yeGxbuZ1Wzv8qhTDkdrIQfxKGkW.jpg"
        }
      ],
      "production_companies" : [
        {
          "logo_path" : "\/nGvh7WJCDYmXZjOAOJ7VoC4vEw0.png",
          "id" : 11226,
          "origin_country" : "US",
          "name" : "FremantleMedia North America"
        }
      ],
      "videos" : {
        "results" : [
          {
            "site" : "YouTube",
            "id" : "5c6ead5f0e0a265627ac27f4",
            "size" : 1080,
            "iso_639_1" : "en",
            "key" : "3awG5wEE7LU",
            "iso_3166_1" : "US",
            "name" : "American Gods | Season 1 Official Trailer Starring Ian McShane & Ricky Whittle | STARZ",
            "type" : "Trailer"
          }
        ]
      },
      "languages" : [
        "en"
      ],
      "spoken_languages" : [
        {
          "english_name" : "English",
          "name" : "English",
          "iso_639_1" : "en"
        }
      ],
      "vote_average" : 7.0999999999999996
    }
    """#
}

