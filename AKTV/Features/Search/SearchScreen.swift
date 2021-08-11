//
//  SearchScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit



//struct Show: Decodable {
//    var backdropPath: String?
//    var firstAirDate: String?
//    var genreIds: [Int]?
//    var id: Int?
//    var name: String?
//    var originCountry: [String]?
//    var originalLanguage: String?
//    var originalName: String?
//    var overview: String?
//    var popularity: Double?
//    var posterPath: String?
//    var voteAverage: Int?
//    var voteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case originCountry = "origin_country"
//        case originalLanguage = "original_language"
//        case originalName = "original_name"
//        case backdropPath = "backdrop_path"
//        case firstAirDate = "first_air_date"
//        case genreIds = "genre_ids"
//        case overview = "overview"
//        case popularity
//        case posterPath = "poster_path"
//    }
//}


/// A film, series, or a game
protocol MediaType: Decodable {
    var name: String { get set }
    var subtitle: String { get set }
}

struct Media: MediaType {
    var name: String
    var subtitle: String
}


// 1. Make SearchScreen take generic MediaSearchResult.
// 2.

class SearchScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    let headerContainer = SearchHeaderContainer()
//    var shows = [Show]()
    var shows = [Media]()

    // MARK: ScrollView Delegate methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let normalized200 = offset.y/200

        if (offset.y > 200) {
            return
        }

        headerContainer.subHeader.alpha = min(1-normalized200, 0.4)
        headerContainer.view.frame.origin.y = -offset.y
    }

    // MARK: TableView Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaSearchResultCell.identifier) ?? MediaSearchResultCell(for: shows[indexPath.row])
        if let cell = cell as? MediaSearchResultCell {
            cell.update(with: show)
        } else {
            fatalError("could not cast to ShowCell")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        detailedShowPresenter?.displayShow(shows[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MediaSearchResultCell.estimatedHeight
    }
}
