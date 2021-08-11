import UIKit


protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

protocol ModelPresenter {
    func displayShow(_ id: Int?)
    func displayEpisode(_ episode: Episode)
}







final class GameSearchScreen: SearchScreen {

    // MARK: - Properties

    // MARK: - Initializers

    // MARK: - Methods

}



final class ShowsSearchScreen: SearchScreen {
    
    // MARK: Properties

    private let episodesSearchResultViewController = UITableViewController()
    private let episodesSearchResultDataDelegate = self
    private let apiDao: APIDAO
    var detailedShowPresenter: ModelPresenter?

    // MARK: Initializers
    
    init(dao: APIDAO) {
        apiDao = dao
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(hex: "#F7F7F7")

        headerContainer.searchField.searchField.delegate = self

        episodesSearchResultViewController.tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        episodesSearchResultViewController.tableView.dataSource = self
        episodesSearchResultViewController.tableView.delegate = self
        episodesSearchResultViewController.tableView.estimatedRowHeight = MediaSearchResultCell.estimatedHeight
        episodesSearchResultViewController.tableView.backgroundColor = .clear
        episodesSearchResultViewController.tableView.separatorStyle = .none

        detailedShowPresenter = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(headerContainer.view)

        headerContainer.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 280)
        view.addSubview(episodesSearchResultViewController.view)
        addChild(episodesSearchResultViewController)
        
        episodesSearchResultViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(headerContainer.view.snp.bottom).offset(32)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - DetailedShowPresenter conformance

extension ShowsSearchScreen: ModelPresenter {
    func displayEpisode(_ episode: Episode) {
        fatalError("SUCCESS! Now actually make VC and present to screen")
    }
    
    func displayShow(_ id: Int?) {
        guard let id = id else { fatalError("Show had no id to present from") }
        
        apiDao.show(withId: id) { (showOverview) in
            DispatchQueue.main.async {
                let next = ShowOverviewScreen(dao: self.apiDao)
                next.update(with: showOverview)
                self.present(next, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Make self textview delegate

extension ShowsSearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        apiDao.searchShows(string: searchterm) { (shows) in
            print("bam searchResult outer: ", shows)
            DispatchQueue.main.async {
                print("bam searchResult innter: ", shows)
                self.shows = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }

        textField.resignFirstResponder()
        return true
    }
}
