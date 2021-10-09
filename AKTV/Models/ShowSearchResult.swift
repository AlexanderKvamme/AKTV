//
//  ShowSearchResult.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

struct TVShowSearchResult: Decodable {
    
    // Properties
    
    var results: [Show]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
