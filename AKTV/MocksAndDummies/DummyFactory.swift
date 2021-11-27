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
