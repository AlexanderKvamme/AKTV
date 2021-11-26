//
//  StreamAvailability.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct StreamExperiment: Codable {
    var tmdbID: String
    var streamingInfo: [String : [String : Country]]
    
    func getStreamingServices() -> [String] {
        let keys = Array(streamingInfo.keys)
        return keys
    }
}

struct Country: Codable, Hashable {
    var link: String
    var added: Int
    var leaving: Int
}

final class StreamAvailability {
    
    private static var subscriptions = Set<AnyCancellable>()
    
    static func makePublisher(tmdbId: UInt64) -> AnyPublisher<StreamExperiment, Error> {
        let urlString =  "https://streaming-availability.p.rapidapi.com/get/basic?country=us&tmdb_id=movie%2F\(tmdbId)&output_language=en"
        let url = URL(string: urlString)!
        var req = URLRequest(url: url)
        req.addValue("streaming-availability.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        req.addValue("77e27739f5mshfb6231d30695dfdp1e5b01jsnc7cd9757ee53", forHTTPHeaderField: "x-rapidapi-key")
        
        let publisher = URLSession.shared.dataTaskPublisher(for: req)
            .map(\.data)
            .eraseToAnyPublisher()
            .decode(type: StreamExperiment.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        return publisher
    }
    
    static func test() {
        let urlString =  "https://streaming-availability.p.rapidapi.com/get/basic?country=us&tmdb_id=movie%2F1538&output_language=en"
        let url = URL(string: urlString)!
        var req = URLRequest(url: url)
        req.addValue("streaming-availability.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        req.addValue("77e27739f5mshfb6231d30695dfdp1e5b01jsnc7cd9757ee53", forHTTPHeaderField: "x-rapidapi-key")
        
        URLSession.shared.dataTaskPublisher(for: req)
            .map(\.data)
            .eraseToAnyPublisher()
            .decode(type: StreamExperiment.self, decoder: JSONDecoder())
            .sink { comp in
                switch comp {
                case .failure:
                    print("Streaming availibility fetch failure")
                case .finished:
                    print("Streaming availibility fetch finished")
                }
            } receiveValue: { experiment in
                let services = experiment.getStreamingServices()
                print("bam resulted in services: ", services)
            }
            .store(in: &subscriptions)
    }
}
