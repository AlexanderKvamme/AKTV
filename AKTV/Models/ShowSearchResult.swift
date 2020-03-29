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
    
    var page: Int
//    var totalPages: Int
    var results: [Show] // dårlg {
    {
        didSet{
            print("bam didset")
        }
    }
    
    // FIXME: Det er results greien som ikke funker
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
    }
}
