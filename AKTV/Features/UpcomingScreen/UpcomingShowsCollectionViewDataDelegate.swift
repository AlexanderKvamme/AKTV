//
//  UpcomingShowsDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All r1ights reserved.
//

import Foundation
import UIKit


final class UpcomingShowsCollectionViewDataDelegate: NSObject, UICollectionViewDelegate {

    // MARK: - Properties

    weak var upcomingScreen: CalendarScreen?
    weak var dataSource: UpcomingDataSource?

    // MARK: - Initializers

    init(_ upcomingScreen: CalendarScreen, dataSource: UpcomingDataSource) {
        self.upcomingScreen = upcomingScreen
        self.dataSource = dataSource
    }

    // MARK: - Delegate Methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let show = dataSource.itemIdentifier(for: indexPath)
        else {
            fatalError("no datasource")
        }

        guard let episode = show.nextEpisodeToAir else {
            print("No next episode to display")
            return
        }

        if let card = collectionView.cellForItem(at: indexPath) as? UpcomingCell {
            upcomingScreen?.didTapCard(card, episode, show)
        }
    }

    // MARK: Internal methods

    func display(episode: Episode, from view: UIView) {
        let episodeScreen = EpisodeScreen(episode)
        episodeScreen.update(with: episode)
        view.findViewController()?.present(episodeScreen, animated: true, completion: nil)
    }
}
