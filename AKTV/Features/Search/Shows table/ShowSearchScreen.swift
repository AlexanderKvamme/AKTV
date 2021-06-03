import UIKit


protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

protocol ModelPresenter {
    func displayShow(_ id: Int?)
    func displayEpisode(_ episode: Episode)
}


private final class HeaderContainer: UIViewController {

    private let headerField = UILabel()
    let searchField = UITextField()

    override func viewDidLoad() {
        setup()
        addSubviewsAndConstraints()
    }

    func setup() {
        headerField.font = UIFont.gilroy(.bold, 20)
        headerField.textAlignment = .center
        headerField.text = "What are you looking for?"
        headerField.textColor = UIColor(dark)

        searchField.textColor = UIColor(light)
        searchField.backgroundColor = .clear
        searchField.textAlignment = .center
        searchField.placeholder = "Game of thrones"
        searchField.font = UIFont.gilroy(.heavy, 60)
        searchField.textColor = UIColor(dark)
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        searchField.adjustsFontSizeToFitWidth = true
    }

    func addSubviewsAndConstraints() {
        view.addSubview(headerField)
        headerField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()//.offset(40)
            make.left.right.bottom.equalToSuperview()
        }

        view.addSubview(searchField)
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(headerField).offset(80)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}


final class ShowsSearchScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    private let episodesSearchResultViewController = UITableViewController()
    private let episodesSearchResultDataDelegate = self
    private let apiDao: APIDAO
    private let headerContainer = HeaderContainer()
    
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
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(hex: "#F6FAFB")

        headerContainer.searchField.delegate = self

        episodesSearchResultViewController.tableView.dataSource = self
        episodesSearchResultViewController.tableView.delegate = self
        episodesSearchResultViewController.tableView.estimatedRowHeight = ShowCell.estimatedHeight
        episodesSearchResultViewController.tableView.backgroundColor = .clear
        episodesSearchResultViewController.tableView.separatorStyle = .none

        detailedShowPresenter = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(headerContainer.view)

        headerContainer.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 240)
        view.addSubview(episodesSearchResultViewController.view)
        addChild(episodesSearchResultViewController)
        
        episodesSearchResultViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(headerContainer.view.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if (offset.y > 200) {
            return
        }

        headerContainer.view.frame.origin.y = -offset.y
    }

    // MARK: Properties

    var shows = [Show]()
    var detailedShowPresenter: ModelPresenter?

    // MARK: Delegate methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCell.identifier) ?? ShowCell(for: shows[indexPath.row])
        cell.backgroundColor = .clear
        if let cell = cell as? ShowCell {
            cell.update(with: show)
        } else {
            fatalError("could not cast to ShowCell")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailedShowPresenter?.displayShow(shows[indexPath.row].id)
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

    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.text = textField.text?.uppercased()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        _ = apiDao.searchShows(string: searchterm) { (shows) in
            DispatchQueue.main.async {
                self.shows = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }

        textField.resignFirstResponder()
        return true
    }
}
