import UIKit


// MARK: - Protocols

protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

protocol ModelPresenter {
    func displayShow(_ id: Int?)
    func displayEpisode(_ episode: Episode)
}

protocol MediaSearcher {
    func search(_ mediaType: MediaType?, _ string: String, andThen: @escaping (([MediaSearchResult]) -> ()))
}
