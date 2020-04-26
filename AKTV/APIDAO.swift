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
    
    // TODO: Make this function actually search and return a lsit of shows after unwrapping result
    func searchShows(string: String, andThen: @escaping (([Show]) -> ())) {
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            fatalError()
        }
        
        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(key)&query=\(encodedString)"
        guard let url = URL(string: urlString) else {
            print("bam Error: Could not make url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                return
            }
            
            guard let content = data else {
                return
            }
            
            // NEW TEST OF CODABLE
            let decoder = JSONDecoder()
            var result: TVShowSearchResult?
            
            do {
                let decoded = try decoder.decode(TVShowSearchResult.self, from: content)
                if let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                }
                
                let results = decoded.results.map({ $0.name })
                result = decoded
                andThen(decoded.results)
            } catch {
                // Got JSON
                guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]
                    else {
                        print("Not containing JSON")
                        return
                }
            }
        }.resume()
    }
    
    // FIXME: Get full tv series out with all seasons and shit
    
    func testGettingAllSeasonsOverview(showId: Int, andThen: @escaping ((ShowOverview) -> ()))  {
        print("bam testGettingAllSeasonsAndEpisodes")
        let showId = String(showId)
        let seasonNumber = "1"
        //            let url = URL(string: root + "tv/" + showId + "/season/" + seasonNumber + "?" + keyParam)
        
        // NY test
        //            let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(key)&query=\(encodedString)"
        let url = URL(string: root + "tv/" + showId + "?" + keyParam)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else {
                print("returning error")
                return
            }
            
            guard let content = data else {
                print("not returning data")
                return
            }
            
            // Got JSON
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            print("bam json: ", json)
            
            // Mapping
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvShowSeason = try! decoder.decode(ShowOverview.self, from: content)
            print()
            print("bam made tvShowSeason: ", tvShowSeason)
            andThen(tvShowSeason)
        }
        
        task.resume()
    }
    
    func episodes(showId: Int, seasonNumber: Int, andThen: @escaping ((Season) -> ())) {
        let showId = String(showId)
        let seasonNumber = String(seasonNumber)

        let url = URL(string: root + "tv/" + showId + "/season/" + seasonNumber + "?" + keyParam)
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else {
                fatalError("error: \(error) ... \(error?.localizedDescription)")
            }
            
            guard let content = data else {
                fatalError("no content")
            }
            
            // Got JSON
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            print("bam json: ", json)
            
            // Mapping
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvShowSeason = try! decoder.decode(Season.self, from: content)
            print()
            print("bam made tvShowSeason: ", tvShowSeason)
            andThen(tvShowSeason)
        }
        
        task.resume()
        
    }
}
