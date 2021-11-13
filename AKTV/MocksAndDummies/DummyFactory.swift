//
//  DummyFactory.swift
//  AKTV
//
//  Created by Alexander Kvamme on 31/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation

extension Show {

    private static var showsJSON: String {
"""
[
        {
            "backdrop_path": "/oWH0Z5lpOnEoo3g2gFHAABtMFC4.jpg",
            "first_air_date": "1986-09-22",
            "genre_ids": [
                10751,
                35,
                18
            ],
            "id": 4658,
            "name": "ALF",
            "origin_country": [
                "US"
            ],
            "original_language": "en",
            "original_name": "ALF",
            "overview": "A furry alien wiseguy comes to live with a terran family after crashing into their garage.",
            "popularity": 37.351,
            "poster_path": "/shRed7ZrCRjdIMEYNx2YBVFkkNu.jpg",
            "vote_average": 7.7,
            "vote_count": 775
        },
        {
            "backdrop_path": "/uKAiYmNqz07NtIYuYsGu6QVldv7.jpg",
            "first_air_date": "1987-09-26",
            "genre_ids": [
                10751,
                16,
                35
            ],
            "id": 11042,
            "name": "ALF: The Animated Series",
            "origin_country": [
                "US"
            ],
            "original_language": "en",
            "original_name": "ALF: The Animated Series",
            "overview": "ALF: The Animated Series is an animated cartoon spin-off based on the live-action Sitcom series ALF. It premiered on September 26, 1987 and ran for 26 episodes. ALF Tales was a spinoff from the series that ran on the NBC television network on Saturdays from August 1988 to December 1989. The show had characters from that series play various characters from fairy tales. The fairy tale was usually altered for comedic effect in a manner relational to Fractured Fairy Tales.",
            "popularity": 4.812,
            "poster_path": "/5Oe2cR9exewLyhfUOWtz7jJLfMy.jpg",
            "vote_average": 6,
            "vote_count": 14
        },
 {
            "backdrop_path": "/oggnxmvofLtGQvXsO9bAFyCj3p6.jpg",
            "first_air_date": "2002-06-02",
            "genre_ids": [
                80,
                18
            ],
            "id": 1438,
            "name": "The Wire",
            "origin_country": [
                "US"
            ],
            "original_language": "en",
            "original_name": "The Wire",
            "overview": "Told from the points of view of both the Baltimore homicide and narcotics detectives and their targets, the series captures a universe in which the national war on drugs has become a permanent, self-sustaining bureaucracy, and distinctions between good and evil are routinely obliterated.",
            "popularity": 57.017,
            "poster_path": "/4lbclFySvugI51fwsyxBTOm4DqK.jpg",
            "vote_average": 8.4,
            "vote_count": 1421
        },
 {
            "backdrop_path": "/5YTM1bh3Jyfy9IP2eS64W3JDeGs.jpg",
            "first_air_date": "2018-06-20",
            "genre_ids": [
                37,
                18
            ],
            "id": 73586,
            "name": "Yellowstone",
            "origin_country": [
                "US"
            ],
            "original_language": "en",
            "original_name": "Yellowstone",
            "overview": "Follow the violent world of the Dutton family, who controls the largest contiguous ranch in the United States. Led by their patriarch John Dutton, the family defends their property against constant attack by land developers, an Indian reservation, and America’s first National Park.",
            "popularity": 198.44,
            "poster_path": "/iqWCUwLcjkVgtpsDLs8xx8kscg6.jpg",
            "vote_average": 7.9,
            "vote_count": 644
        },
    ]
"""
    }

    static var mocks: [Show] {
        let json = JSONDecoder()
        let res = try! json.decode([Show].self, from: Data(showsJSON.utf8))
        return res
    }
}
