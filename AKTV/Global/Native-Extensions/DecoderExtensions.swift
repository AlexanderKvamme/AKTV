//
//  DecoderExtensions.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/09/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static let snakeCaseConverting: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
