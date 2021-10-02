//
//  APIDAO.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import IGDB_SWIFT_API

// MARK: - Protocols

enum MediaType {
    case movie, series, game
}

protocol MediaSearchResult {
    var name: String { get }
    var id: UInt64 { get }
}

extension Proto_Game: MediaSearchResult {}

// MARK: - APIDAO

final class APIDAO: NSObject, MediaSearcher {
    
    // MARK: Properties
    
    private let root = "https://api.themoviedb.org/3/"
    private let keyParam = "api_key=a1549fe4c5cb82a960b858411d70112c"
    static let imdbImageRoot = "https://image.tmdb.org/t/p/original/"

    static let igdbImageRoot = "https://api.igdb.com/v4/covers/"

    typealias JSONCompletion = (([String: Any]?) -> Void)

    // TODO: Dont default
    func search(_ type: MediaType? = MediaType.series, _ string: String, andThen: @escaping (([MediaSearchResult]) -> ())) {
        switch type {
        case .series:
            searchSeries(string, andThen: andThen)
        case .game:
            searchGames(string, andThen: andThen)
        default:
            fatalError("Not yet implemented")
        }
    }

    func searchSeries( _ string: String, andThen: @escaping (([Show]) -> ())) {
        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            fatalError()
        }

        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=\(key)&query=\(encodedString)"
        guard let url = URL(string: urlString) else {
            print("Error: Could not make url")
            return
        }

        let _ = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                return
            }

            guard let content = data else {
                return
            }

            let decoder = JSONDecoder()

            do {
                let decoded = try decoder.decode(TVShowSearchResult.self, from: content)
                if let _ = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                }

                let results = decoded.results.map({ $0.name })
                andThen(decoded.results)
            } catch {
                // Got JSON
                guard let _ = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]
                    else {
                        print("Not containing JSON")
                        return
                }
            }
        }.resume()
    }

    func searchGames( _ string: String, andThen: @escaping (([Proto_Game]) -> ())) {
        guard let authToken = GameService.authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .search(searchQuery: string)
            .fields(fields: "name")

        wrapper.games(apiCalypse: apicalypse, result: { searchResults in
            andThen(searchResults)
        }) { error in
            print("Search games Error: ", error)
        }
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

    func game(withId: UInt64, andThen: @escaping ((Proto_Game) -> ()))  {
        guard let authToken = GameService.authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .where(query: "id = \(withId);")
            .fields(fields: "*")
        wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            if let game = games.first {
                andThen(game)
            } else {
                print("Error: Too many games to handle")
            }
        } errorResponse: { (requestException) -> (Void) in
            print("Request exception: ", requestException)
        }
    }

    func getGameReleaseDate(_ releaseDateId: Int, andThen: @escaping (([Date]) -> ())) {
        guard let authToken = GameService.authToken else {
            print("Missing authToken")
            return
        }

        let gameId = DummyGameIDs.diablo2Resurrected
        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .where(query: "game = \(gameId);")
            .fields(fields: "*")

        wrapper.releaseDates(apiCalypse: apicalypse) { releasedates in
            let dates = releasedates.map({$0.date.date})
            andThen(dates)
        } errorResponse: { reqException in
            print("reqException: ", reqException)
        }
    }
}


class DummyGameIDs {
    static let diablo2Resurrected = 142803
}
