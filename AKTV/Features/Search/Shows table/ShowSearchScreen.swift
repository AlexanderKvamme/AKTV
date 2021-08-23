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
    func search(_ string: String, andThen: @escaping (([Media]) -> ()))
}

// MARK: - Classes

final class GameSearchScreen: SearchScreen {

    // MARK: - Properties

    // MARK: - Initializers

//    init(dao: MediaSearcher) {
//        self.dao = dao
//        super.init
//        setup()
//        addSubviewsAndConstraints()
//    }

    // MARK: - Methods

}



final class ShowsSearchScreen: SearchScreen {
    
    // MARK: Properties

//    private let episodesSearchResultViewController = UITableViewController()
//    private let episodesSearchResultDataDelegate = self
//    private var dao: APIDAO
//    var detailedShowPresenter: ModelPresenter?

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Private methods
    

}
