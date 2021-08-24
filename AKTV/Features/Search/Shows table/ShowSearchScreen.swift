import UIKit


// MARK: - Protocols

protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

protocol ModelPresenter {
    func display(_ searchResult: MediaSearchResult)
    func displayShow(_ id: UInt64?)
    func displayEpisode(_ episode: Episode)
}

protocol MediaSearcher {
    func search(_ mediaType: MediaType?, _ string: String, andThen: @escaping (([MediaSearchResult]) -> ()))
}
