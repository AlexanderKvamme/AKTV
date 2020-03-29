//
//  APIDAO.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

// MARK: - APIDAO

final class APIDAO: NSObject {
    
    // MARK: Properties
    
    private let root = "https://api.themoviedb.org/3/"
    private let keyParam = "api_key=a1549fe4c5cb82a960b858411d70112c"
    
    // MARK: Initializers
    
//    init(_ networker: Networker) {
//        self.networker = networker
//    }
    
    // MARK: Private methods
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    // TODO: Del opp i mindre
//    func search(name: String) -> [Series] {
//        print("bam would search ")
//        print("bam fix real return")
//        return []
//    }
    
    // Networking
    // TODO: Move away
    // TODO: Make generic
    
    typealias JSONCompletion = (([String: Any]?) -> Void)
    
//    func fetch<T: Codable>(type: T, from url: URL, andThen completion: @escaping JSONCompletion){
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard error == nil else {
//                print("returning error")
//                return
//            }
//
//            guard let content = data else {
//                print("not returning data")
//                return
//            }
//
//            // NEW TEST OF CODABLE
//            let decoder = JSONDecoder()
//
//            do {
//                print("bam tryna decode from content: ", content)
//                let decoded = try decoder.decode(T.self, from: content)
//                print("bam decoded: ", decoded)
//            } catch {
//                print("Error could not decode a tv show 2")
//            }
//
//            // OLD
//
//            // Got JSON
//            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                print("Not containing JSON")
//                completion(nil)
//                return
//            }
//
//            completion(json)
//        }
//        task.resume()
//    }
    
    // TODO: Return a model
    
    // FIXME: Make this function actually search and return a lsit of shows after unwrapping result
    func searchShows(string: String) -> [Show] {
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            fatalError()
        }
        
        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(key)&query=\(encodedString)"
        guard let url = URL(string: urlString) else {
            print("bam Error: Could not make url")
            return []
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            // NEW TEST OF CODABLE
            let decoder = JSONDecoder()
            
            print("bam searchTvShows for ", string)
            do {
                print("bam tryna decode from content: ", content)
                let decoded = try decoder.decode(TVShowSearchResult.self, from: content)
                print("bam decoded TVShowSearchResult: ", decoded)
                
                // Print json
                if let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                    
                    print("decoded to json: ", json)
                }
                
                let results = decoded.results.map({ $0.name })
                print("the mapped results: ", results)
                
            } catch {
                print("Error could not decode a tv show 1. Printing json")
                
                            // Got JSON
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]
                    else {
                    print("Not containing JSON")
                    return
                }
                
                print("bam json: ", json)
            }
            
            // OLD
            
            // Got JSON
//            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                print("Not containing JSON")
//                completion(nil)
//                return
//            }
            
//            completion(json)
        }.resume()
        return [Show]()
    }
    
//    func trytestMappingBBT()  {
//        let showId = "1418"
//        let seasonNumber = "1"
//        let url = URL(string: root + "tv/" + showId + "/season/" + seasonNumber + "?" + keyParam)
//            
//        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//            guard error == nil else {
//                print("returning error")
//                return
//            }
//            
//            guard let content = data else {
//                print("not returning data")
//                return
//            }
//            
//            // Got JSON
//            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                print("Not containing JSON")
//                return
//            }
//            
//            let tvShowSeason = try! JSONDecoder().decode(Season.self, from: content)
//            print("bam made tvShowSeason: ", tvShowSeason)
//            
//            //                print("bam full json: ", json)
//            
//            // Initializes a Foo object from the JSON data at the top.
//            
//            // WORKING
//            
//            //                if let airdate = json["poster_path"] as? String {
//            //                    print("bam had poster")
//            //                } else {
//            //                    print("no poster")
//            //                }
//            //
//            //                if let episodes =  json["episodes"] as? [[String: Any]] {
//            //                    print("bam had episodes")
//            //                    for e in episodes {
//            //                        print("bam got episode: ", e["air_date"] as? String)
//            //                    }
//            //                } else {
//            //                    print("bam no episodes")
//            //                }
//        }
//        
//        task.resume()
//    }
    
//    func episodes(showId: String, seasonNumber: String) {
//        let url = URL(string: root + "tv/" + showId + "/season/" + seasonNumber + "?" + keyParam)
//
//        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
//            guard error == nil else {
//                print("returning error")
//                return
//            }
//
//            guard let content = data else {
//                print("not returning data")
//                return
//            }
//
//            // Got JSON
//            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
//                print("Not containing JSON")
//                return
//            }
//
//            print("bam full json: ", json)
//
//            if let airdate = json["poster_path"] as? String {
//                print("bam had poster")
//            } else {
//                print("no poster")
//            }
//
//            if let episodes =  json["episodes"] as? [[String: Any]] {
//                print("bam had episodes")
//                for e in episodes {
//                    print("bam got episode: ", e["air_date"] as? String)
//                }
//            } else {
//                print("bam no episodes")
//            }
//        }
//
//        task.resume()
//    }
}
