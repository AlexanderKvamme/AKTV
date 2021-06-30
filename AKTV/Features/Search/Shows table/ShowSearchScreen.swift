import UIKit


final class SearchShowTextField: UIView {

    // MARK: - Properties

    let searchField = UITextField()
    let shadowView = ShadowView2(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        searchField.backgroundColor = .clear
        searchField.textAlignment = .center
        searchField.placeholder = "Game of thrones"
        searchField.font = UIFont.gilroy(.bold, 24)
        searchField.textColor = UIColor(light)
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        searchField.adjustsFontSizeToFitWidth = true
        searchField.layer.cornerCurve = .continuous
        searchField.layer.cornerRadius = 16

        searchField.backgroundColor = UIColor(dark)
    }

    private func addSubviewsAndConstraints() {
        addSubview(shadowView)
        addSubview(searchField)

        searchField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().offset(16)
        }

        shadowView.snp.makeConstraints { make in
            make.top.equalTo(searchField).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(searchField).offset(-8)
        }
    }
}

protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

protocol ModelPresenter {
    func displayShow(_ id: Int?)
    func displayEpisode(_ episode: Episode)
}


private final class HeaderContainer: UIViewController {

    private let header = UILabel()
    private let subHeader = UILabel()
    let searchField = SearchShowTextField(frame: .zero)

    override func viewDidLoad() {
        setup()
        addSubviewsAndConstraints()
    }

    func setup() {
        header.font = UIFont.gilroy(.heavy, 38)
        header.textAlignment = .left
        header.text = "What are you looking for?"
        header.textColor = UIColor(dark)
        header.numberOfLines = 0

        subHeader.font = UIFont.gilroy(.regular, 20)
        subHeader.textAlignment = .left
        subHeader.alpha = 0.4
        subHeader.text = "Search for any TV show in the world!"
        subHeader.textColor = UIColor(dark)
        subHeader.numberOfLines = 0
    }

    func addSubviewsAndConstraints() {
        let hInset: CGFloat = 40
        let vinset: CGFloat = 16

        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(80).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(subHeader)
        subHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(vinset).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(searchField)
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(subHeader.snp.bottom).offset(vinset).priority(.low)
            make.left.right.equalToSuperview().inset(hInset)
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
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
        view.backgroundColor = UIColor(hex: "#F7F7F7")

        headerContainer.searchField.searchField.delegate = self

        episodesSearchResultViewController.tableView.dataSource = self
        episodesSearchResultViewController.tableView.delegate = self
        episodesSearchResultViewController.tableView.estimatedRowHeight = ShowCell.estimatedHeight
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
        textField.text = textField.text//?.uppercased()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        apiDao.searchShows(string: searchterm) { (shows) in
            DispatchQueue.main.async {
                self.shows = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }

        textField.resignFirstResponder()
        return true
    }
}
