//
//  ShowListScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ComplimentaryGradientView
import SwiftUI

// NEW: UIKit wrapper

struct ShowOverViewSUWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> ShowOverviewScreen {
        let controller = ShowOverviewScreen(dao: APIDAO())
        return controller
    }

    func updateUIViewController(_ uiViewController: ShowOverviewScreen, context: Context) {
        // ...
    }
}

// OLD

extension ShowOverviewScreen: SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?) {
        guard
            let seasonNumber = seasonNumber,
            let showId = showId else {
                fatalError("Show had no id to present from")
        }
        
        apiDao.episodes(showId: showId, seasonNumber: seasonNumber) { (season) in
            DispatchQueue.main.sync {
                let seasonScreen = SeasonScreen()
                seasonScreen.update(with: season)
                self.present(seasonScreen, animated: true, completion: nil)
            }
        }
    }
}

final class ShowOverviewScreen: UIViewController {
    
    // MARK: Properties
    
    private let header = MotionHeaderView()
    private let showOverviewViewController = UIViewController()
    private let showOverviewDataDelegate = ShowOverviewDataDelegate()
    private let tableView = UITableView()
    private let apiDao: APIDAO
    private let backgroundView = ComplimentaryGradientView()
    
    // MARK: Initializers
    
    init(dao: APIDAO) {
        self.apiDao = dao
        
        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(light)

        tableView.backgroundColor = UIColor(light)
        tableView.separatorStyle = .none
        tableView.delegate = showOverviewDataDelegate
        tableView.dataSource = showOverviewDataDelegate
        showOverviewDataDelegate.seasonPresenter = self
    }
    
    private func addSubviewsAndConstraints() {
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 500)
        tableView.tableHeaderView = header

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Internal methods
    
    func update(with showOverview: ShowOverview) {
        showOverviewDataDelegate.showOverview = showOverview
        header.update(withShow: showOverview)
    }
}

// MARK: - Make self textview delegate

extension ShowOverviewScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fatalError()
        if textField.text != nil {
//            let tvSeries = apiDao.searchShows(string: searchterm)
            // TODO: Actually return a show or somethin
        }
        
        return true
    }
}

// MARK: - Make self episodesdelegate

struct Series {
    let name: String
}

protocol SeriesReceiver {
    func receive(series: [Series])
}

extension ShowOverviewScreen: SeriesReceiver {
    func receive(series: [Series]) {
        print("returned series: ", series)
    }
}









final class MovieScreen: UIViewController {

    // MARK: Properties

    private let header = MotionHeaderView()
    private let showOverviewViewController = UIViewController()
    private let tableView = UITableView()
    private let apiDao: APIDAO
    private let backgroundView = ComplimentaryGradientView()

    // MARK: Initializers

    init(dao: APIDAO) {
        self.apiDao = dao

        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        view.backgroundColor = UIColor(light)

        tableView.backgroundColor = UIColor(light)
        tableView.separatorStyle = .none

        view.backgroundColor = .green
    }

    private func addSubviewsAndConstraints() {
        header.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 500)
        tableView.tableHeaderView = header

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Internal methods

    func update(with movie: Movie) {
        header.update(withMovie: movie)
    }
}
