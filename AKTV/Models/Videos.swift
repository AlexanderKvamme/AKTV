//
//  Videos.swift
//  AKTV
//
//  Created by Alexander Kvamme on 16/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation

/*
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
}
*/

struct Videos: Codable {
    var results: [VideosResults]?
}

struct VideosResults: Codable {
    var site: String
    var id: String
    var key: String?
    var size: Int
    var name: String
    var type: String
    var iso6391: String
}
