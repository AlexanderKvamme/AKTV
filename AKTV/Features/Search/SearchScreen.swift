//
//  SearchScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

// MARK: - Protocols

/// A film, series, or a game
//protocol MediaType {
//    var name: String { get set }
//    var subtitle: String { get set }
//}




struct Media: Decodable {
    var name: String
//    var subtitle: String
}


// 1. Make SearchScreen take generic MediaSearchResult.
// 2.

class SearchScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    let headerContainer = SearchHeaderContainer()
    private let episodesSearchResultViewController = UITableViewController()
    private let episodesSearchResultDataDelegate = self
    var detailedShowPresenter: ModelPresenter?
    var searchResults = [MediaSearchResult]()
    var dao: MediaSearcher
    var searchTypes: MediaType

    // MARK: - Initializer

    init(dao: MediaSearcher, searchTypes: MediaType) {
        self.dao = dao
        self.searchTypes = searchTypes
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

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
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaSearchResultCell.identifier) ?? MediaSearchResultCell(for: searchResults[indexPath.row])
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

// MARK: - Make self textview delegate

extension SearchScreen: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }

        dao.search(searchTypes, searchterm) { (shows) in
            print("bam searchResult outer: ", shows)
            DispatchQueue.main.async {
                print("bam searchResult innter: ", shows)
                self.searchResults = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }

        textField.resignFirstResponder()
        return true
    }
}

// MARK: - DetailedShowPresenter conformance

extension SearchScreen: ModelPresenter {

    func displayEpisode(_ episode: Episode) {
        fatalError("SUCCESS! Now actually make VC and present to screen")
    }

    func displayShow(_ id: Int?) {
        guard let id = id else { fatalError("Show had no id to present from") }

//        dao.show(withId: id) { (showOverview) in
//            DispatchQueue.main.async {
//                let next = ShowOverviewScreen(dao: self.dao)
//                next.update(with: showOverview)
//                self.present(next, animated: true, completion: nil)
//            }
//        }
    }
}