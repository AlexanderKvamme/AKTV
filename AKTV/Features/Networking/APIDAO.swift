//
//  APIDAO.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

// MARK: - APIDAO

final class APIDAO: NSObject, MediaSearcher {
    
    // MARK: Properties
    
    private let root = "https://api.themoviedb.org/3/"
    private let keyParam = "api_key=a1549fe4c5cb82a960b858411d70112c"
    static let imageRoot = "https://image.tmdb.org/t/p/original/"
    
    typealias JSONCompletion = (([String: Any]?) -> Void)

    func search(_ string: String, andThen: @escaping (([Media]) -> ())) {
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            fatalError()
        }
        
        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(key)&query=\(encodedString)"
        guard let url = URL(string: urlString) else {
            print("Error: Could not make url")
            return
        }
        
        let _ = URLSession.shared.dataTask(with: url) {(data, response, error) in
            print("bam data response: ", data)
            guard error == nil else {
                return
            }
            
            guard let content = data else {
                return
            }
            
            let decoder = JSONDecoder()
            var result: MediaSearchResult?
            
            do {
                print("bam tryna decode")
                let decoded = try decoder.decode(MediaSearchResult.self, from: content)
                print("bam decoded: ", decoded)
                if let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                }
                
                let results = decoded.results.map({ $0.name })

                print("bam results: ", results)
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
    
    func show(withId: Int, andThen: @escaping ((ShowOverview) -> ()))  {
        let showId = String(withId)
        let url = URL(string: root + "tv/" + showId + "?" + keyParam + "&append_to_response=videos")
        
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
            guard ((try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]) != nil else {
                print("Not containing JSON")
                return
            }

            // Mapping
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvShowSeason = try! decoder.decode(ShowOverview.self, from: content)
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
                fatalError("error: \(String(describing: error)) ... \(String(describing: error?.localizedDescription))")
            }
            
            guard let content = data else {
                fatalError("no content")
            }
            
            // Got JSON
            guard ((try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]) != nil else {
                print("Not containing JSON")
                return
            }
            
            // Mapping
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvShowSeason = try! decoder.decode(Season.self, from: content)
            andThen(tvShowSeason)
        }
        
        task.resume()
        
    }

    func game(withId: Int, andThen: @escaping ((ShowOverview) -> ()))  {

        // FIXME: ACTUALLY GET GAMES
        
        let showId = String(withId)
        let url = URL(string: root + "tv/" + showId + "?" + keyParam + "&append_to_response=videos")

        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard error == nil else {
                print("returning error")
                return
            }

            guard let content = data else {
                print("not returning data")
                return
            }

            guard ((try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]) != nil else {
                print("Not containing JSON")
                return
            }

            // Mapping
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvShowSeason = try! decoder.decode(ShowOverview.self, from: content)
            andThen(tvShowSeason)
        }

        task.resume()
    }
}
