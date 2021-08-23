//
//  ShowSearchResult.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

struct MediaSearchResult: Decodable {
    
    // Properties
    
    var page: Int
//    var totalPages: Int
    var results: [Media]
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}
