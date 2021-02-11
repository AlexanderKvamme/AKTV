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
//    var voteAverage: Int
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
      "backdrop_path": "/8x8ODgeIwV2QbuWp73QVU4ilEN9.jpg",
      "created_by": [
        {
          "id": 1213753,
          "credit_id": "5257514d760ee36aaa1c256b",
          "name": "Peter Casey",
          "gender": 2,
          "profile_path": null
        },
        {
          "id": 1213757,
          "credit_id": "5257514d760ee36aaa1c2565",
          "name": "David Angell",
          "gender": 2,
          "profile_path": null
        }
      ],
      "episode_run_time": [
        24
      ],
      "first_air_date": "1993-09-16",
      "genres": [
        {
          "id": 35,
          "name": "Comedy"
        }
      ],
      "homepage": "",
      "id": 3452,
      "in_production": false,
      "languages": [
        "en"
      ],
      "last_air_date": "2004-05-13",
      "last_episode_to_air": {
        "air_date": "2004-05-13",
        "episode_number": 24,
        "id": 249918,
        "name": "Goodnight, Seattle (2)",
        "overview": "Daphne gives birth to a healthy son, David.  Frasier marries Martin and Ronee in the vet's office before Daphne and the baby leave for the hospital.  Frasier grows very lonely with Martin out of the apartment and Daphne and Niles busy with their son.  He decides to take the San Francisco job.  Roz is named Kenny's replacement as station manager, and gives Noel a kiss during her celebration!  Frasier tells his family and Roz about his upcoming move, following a misunderstanding that leads them to believe he is dying.  He promises to visit frequently.  Frasier makes a speech to the group, and again on his final show at KACL, about the importance of taking chances.  His seatmate on the plane thanks him for the stimulating conversation as their plane finally lands...in Chicago.",
        "production_code": "",
        "season_number": 11,
        "still_path": "/9txvhNGhKcbRWWLItf4cUY8Sl0G.jpg",
        "vote_average": 0,
        "vote_count": 0
      },
      "name": "Frasier",
      "next_episode_to_air": null,
      "networks": [
        {
          "name": "NBC",
          "id": 6,
          "logo_path": "/o3OedEP0f9mfZr33jz2BfXOUK5.png",
          "origin_country": "US"
        }
      ],
      "number_of_episodes": 264,
      "number_of_seasons": 11,
      "origin_country": [
        "US"
      ],
      "original_language": "en",
      "original_name": "Frasier",
      "overview": "After many years spent at the “Cheers” bar, Frasier moves back home to Seattle to work as a radio psychiatrist after his policeman father gets shot in the hip on duty.",
      "popularity": 59.31,
      "poster_path": "/gYAb6GCVEFsU9hzMCG5rxaxoIv3.jpg",
      "production_companies": [
        {
          "id": 55016,
          "logo_path": null,
          "name": "Grammnet Productions",
          "origin_country": "US"
        },
        {
          "id": 65426,
          "logo_path": null,
          "name": "Grub Street Productions",
          "origin_country": ""
        },
        {
          "id": 9223,
          "logo_path": "/1nfcdPtyI7j9Err6cfrXNvlONEK.png",
          "name": "Paramount Television Studios",
          "origin_country": "US"
        }
      ],
      "production_countries": [],
      "seasons": [
        {
          "air_date": "2001-11-13",
          "episode_count": 30,
          "id": 10559,
          "name": "Specials",
          "overview": "",
          "poster_path": "/5OwBa8zJwdyHEcQOxyvp6Gil9GG.jpg",
          "season_number": 0
        },
        {
          "air_date": "1993-09-16",
          "episode_count": 24,
          "id": 10550,
          "name": "Season 1",
          "overview": "The first season of Frasier originally aired from September 16, 1993 to May 19, 1994 on NBC.",
          "poster_path": "/dqHXMRTaL1WhtjfuOop8tFXDVPn.jpg",
          "season_number": 1
        },
        {
          "air_date": "1994-09-20",
          "episode_count": 24,
          "id": 10548,
          "name": "Season 2",
          "overview": "The second season of Frasier originally aired from September 20, 1994 to May 23, 1995 on NBC.",
          "poster_path": "/yzPW4N1dXHZUSXZmQ01FSdJmklr.jpg",
          "season_number": 2
        },
        {
          "air_date": "1995-09-19",
          "episode_count": 24,
          "id": 10552,
          "name": "Season 3",
          "overview": "The third season of Frasier originally aired from September 19, 1995 to May 21, 1996 on NBC.",
          "poster_path": "/jRTX4aRn9s3U4Lc3JLFBw1z7z4R.jpg",
          "season_number": 3
        },
        {
          "air_date": "1996-09-17",
          "episode_count": 24,
          "id": 10549,
          "name": "Season 4",
          "overview": "The fourth season of Frasier originally aired from September 17, 1996 to May 20, 1997 on NBC.",
          "poster_path": "/7QYcnK8BRBE5kbbwmkIvguDSnMu.jpg",
          "season_number": 4
        },
        {
          "air_date": "1997-09-23",
          "episode_count": 24,
          "id": 10553,
          "name": "Season 5",
          "overview": "The fifth season of Frasier originally aired from September 23, 1997 to May 19, 1998 on NBC.",
          "poster_path": "/6amcFkJJnyp1J68P5OGmEOSIPcs.jpg",
          "season_number": 5
        },
        {
          "air_date": "1998-09-24",
          "episode_count": 24,
          "id": 10551,
          "name": "Season 6",
          "overview": "The sixth season of Frasier originally aired from September 24, 1998 to May 29, 1999 on NBC.",
          "poster_path": "/9iVRnF4G0TYBd0VflU0RcPFQ8Ls.jpg",
          "season_number": 6
        },
        {
          "air_date": "1999-09-23",
          "episode_count": 24,
          "id": 10554,
          "name": "Season 7",
          "overview": "The seventh season of Frasier originally aired from September 23, 1999 to May 18, 2000 on NBC.",
          "poster_path": "/5hEgeALKxPleasEBtIaPJbnQslt.jpg",
          "season_number": 7
        },
        {
          "air_date": "2000-10-24",
          "episode_count": 24,
          "id": 10557,
          "name": "Season 8",
          "overview": "The eighth season of Frasier originally aired from October 24, 2000 to May 22, 2001 on NBC.",
          "poster_path": "/4wrxtEjITUPeILnknJS4rpjIvTk.jpg",
          "season_number": 8
        },
        {
          "air_date": "2001-09-25",
          "episode_count": 24,
          "id": 10555,
          "name": "Season 9",
          "overview": "The ninth season of Frasier was a 24 episode season, that ran from September 2001 to May 2002, beginning on 25 September 2001.",
          "poster_path": "/jifBdZ8cL41Ebq8JPx8WUD0EWVQ.jpg",
          "season_number": 9
        },
        {
          "air_date": "2002-09-24",
          "episode_count": 24,
          "id": 10556,
          "name": "Season 10",
          "overview": "The tenth season of Frasier originally aired from September 9, 2002 and May 20, 2003 on NBC. A disclaimer appears on the backside of the Season 10 DVD box which states \"Some episodes may be edited from their original network versions\". However, it is unclear as to which episodes were edited, whether these are the syndicated versions, or whether music was replaced for certain episodes due to licensing issues.",
          "poster_path": "/jGXlcRV6emC3pNs1m61Y19xnRMp.jpg",
          "season_number": 10
        },
        {
          "air_date": "2003-09-23",
          "episode_count": 24,
          "id": 10558,
          "name": "Season 11",
          "overview": "The 11th and final season of the American situation comedy television series Frasier originally aired from September 23, 2003 to May 13, 2004 on NBC.\n\nOn May 13, 2004 a special episode, \"Analyzing the Laughter\" was shown.",
          "poster_path": "/4zGkr9jRspy2k9up59B3TQdqg5H.jpg",
          "season_number": 11
        }
      ],
      "spoken_languages": [
        {
          "english_name": "English",
          "iso_639_1": "en",
          "name": "English"
        }
      ],
      "status": "Ended",
      "tagline": "",
      "type": "Scripted",
      "vote_average": 7.6,
      "vote_count": 392
    }
    """#
}

