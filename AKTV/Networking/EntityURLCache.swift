//
//  EntityURLCache.swift
//  AKTV
//
//  Created by Alexander Kvamme on 18/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import Foundation


class EntityURLCache: URLCache {
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        guard let response = cachedResponse.response as? HTTPURLResponse else {
            NSLog("couldn't convert to http response")
            return
        }

        guard response.statusCode == 200 else {
            if response.statusCode == 429 {
                NSLog("Over API Hourly Limit")
            } else {
                NSLog("\(response.statusCode)")
            }
            return
        }

        // Override cache with one use one week
        var headers = response.allHeaderFields
        headers.removeValue(forKey: "Cache-Control")
        headers["Cache-Control"] = "max-age=\(7 * 24 * 60 * 60)"
        
        if let headers = headers as? [String: String],
            let newHTTPURLResponse = HTTPURLResponse(url: response.url!, statusCode: response.statusCode, httpVersion: "HTTP/1.1", headerFields: headers) {
            let newCachedResponse = CachedURLResponse(response: newHTTPURLResponse, data: cachedResponse.data)
            super.storeCachedResponse(newCachedResponse, for: request)
        }
    }
}
