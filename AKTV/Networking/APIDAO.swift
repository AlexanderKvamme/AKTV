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
        case .movie:
            searchMovies(string, andThen: andThen)
        default:
            fatalError("Not yet implemented")
        }
    }

    func searchMovies( _ string: String, andThen: @escaping (([Movie]) -> ())) {
        print("searching for", string)

        guard let encodedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            fatalError()
        }

        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(key)&query=\(encodedString)"
        guard let url = URL(string: urlString) else {
            print("Error: Could not make url")
            return
        }

        let _ = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print("Search movies Error: ", error.localizedDescription)
                print(error)
                return
            }

            guard let content = data else {
                print("no content")
                return
            }


            let decoder = JSONDecoder()

            do {

                if let data = data {
                    if let str = String(data: data, encoding: .utf8) {

                        // OLD
                        let decoded = try decoder.decode(MovieSearchResult.self, from: content)
                        andThen(decoded.results)
                    }
                }
            } catch let error {
                // Got JSON
                print("catch: ", error)
                guard let _ = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any]
                    else {
                        print("Not containing JSON")
                        return
                }
            }
        }.resume()
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
            if let error = error {
                print("Search series error: ", error.localizedDescription)
                print(error)
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
    
    func showOverview(withId: Int, andThen: @escaping ((ShowOverview) -> ()))  {
        let showId = String(withId)
        let url = URL(string: root + "tv/" + showId + "?" + keyParam + "&append_to_response=videos")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                print("Show with ID error: ", error.localizedDescription)
                print(error)
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

    func show(withId: Int, andThen: @escaping ((Show) -> ()))  {
        let showId = String(withId)
        let url = URL(string: root + "tv/" + showId + "?" + keyParam + "&append_to_response=videos")

        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                print("Show with ID error: ", error.localizedDescription)
                print(error)
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
            let show = try! decoder.decode(Show.self, from: content)
            andThen(show)
        }

        task.resume()
    }

    func movie(withId: UInt64, andThen: @escaping ((Movie) -> ()))  {
        let showId = String(withId)
        let url = URL(string: root + "movie/" + showId + "?" + keyParam + "&append_to_response=videos")

        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                print("Movie with ID error: ", error.localizedDescription)
                print(error)
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
            let movie = try! decoder.decode(Movie.self, from: content)
            andThen(movie)
        }

        task.resume()
    }

    func episodes(showId: Int, seasonNumber: Int, andThen: @escaping ((Season) -> ())) {
        let seasonNumber = String(seasonNumber)
        let url = URL(string: root + "tv/" + String(showId) + "/season/" + seasonNumber + "?" + keyParam)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                print(error)
                return
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
            var tvShowSeason = try! decoder.decode(Season.self, from: content)

            // Add showId to episodes
            var updatedEpisodes = [Episode]()
            for episode in tvShowSeason.episodes {
                let test = Episode(name: episode.name, episodeNumber: episode.episodeNumber, airDate: episode.airDate, id: episode.id, overview: episode.overview, seasonNumber: episode.seasonNumber, stillPath: episode.stillPath, voteAverage: episode.voteAverage, showId: showId, artPath: tvShowSeason.posterPath)
                updatedEpisodes.append(test)
            }

            tvShowSeason.episodes = updatedEpisodes

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
