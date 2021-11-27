//
//  Movie.swift
//  AKTV
//
//  Created by Alexander Kvamme on 06/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation

struct Movie: Codable, Hashable, Identifiable, MediaSearchResult {

    // MARK: - Properties

    var name: String
    var id: UInt64

    var adult: Bool?
    var backdropPath: String?
    var genreIds: [Int]?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var videos: Videos?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case name = "title"
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos = "videos"
        case status = "status"
    }
}

// MARK: - TMDBPresentable

extension Movie: TMDBPresentable {
    func getId() -> Int {
        return Int(id)
    }

    func getVoteAverage() -> Double {
        return voteAverage ?? 0
    }
}



struct MovieSearchResult: Decodable {

    // Properties

    var results: [Movie]

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

