//
//  EntityURLCache.swift
//  AKTV
//
//  Created by Alexander Kvamme on 18/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class EntityURLCache: NSURLCache {
    override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forRequest request: NSURLRequest) {

        // 1
        guard let response = cachedResponse.response as? NSHTTPURLResponse else {
            NSLog("couldn't convert to http response")
            return
        }

        // 2
        guard response.statusCode == 200 else {
            if response.statusCode == 429 {
                NSLog("Over API Hourly Limit")
            } else {
                NSLog("\(response.statusCode)")
            };
            return
        }

        // 3
        var headers = response.allHeaderFields
        headers.removeValueForKey("Cache-Control")
        headers["Cache-Control"] = "max-age=\(7 * 24 * 60 * 60)"

        // 4
        if let
            headers = headers as? [String: String],
            newHTTPURLResponse = NSHTTPURLResponse(URL: response.URL!, statusCode: response.statusCode, HTTPVersion: "HTTP/1.1", headerFields: headers) {
                let newCachedResponse = NSCachedURLResponse(response: newHTTPURLResponse, data: cachedResponse.data)
                super.storeCachedResponse(newCachedResponse, forRequest: request)
        }
    }
}
//}
