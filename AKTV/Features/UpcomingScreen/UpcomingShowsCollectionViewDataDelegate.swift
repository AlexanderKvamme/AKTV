//
//  UpcomingShowsDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import SwiftUI


final class UpcomingShowsCollectionViewDataDelegate: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: Properties

    private var data = [ShowOverview]()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingCell.identifier, for: indexPath) as? UpcomingCell ?? UpcomingCell()
        cell.update(with: data[indexPath.row])
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episode = data[indexPath.row].nextEpisodeToAir else {
            print("No next episode to display info about")
            return
        }

        display(episode: episode, from: collectionView)
    }

    // MARK: Internal methods

    // TODO: Use this and gather all shows in one fetch
    func update(withShows shows: [ShowOverview]) {
        fatalError("Implement me")
    }

    func update(withShow show: ShowOverview) {
        data.append(show)
    }

    // MARK: - Helper methods

    func display(episode: Episode, from view: UIView) {
        let episodeScreen = EpisodeScreen(episode)
        view.findViewController()?.present(episodeScreen, animated: true, completion: nil)
    }
}

