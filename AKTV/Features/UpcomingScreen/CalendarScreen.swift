//
//  UpcomingScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Types and typealiases

enum UpcomingSection: Int, CaseIterable {
    case tvShows
}

typealias UpcomingDataSource = UICollectionViewDiffableDataSource<UpcomingSection, ShowOverview>

extension CalendarScreen: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cell = tappedCell else { return nil }

        return UpcomingToDetailedAnimationController(cell)
    }
}


final class CalendarScreen: UIViewController {
    func makeDataSource() -> UpcomingDataSource {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, showOverview in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UpcomingCell.identifier,
                    for: indexPath
                ) as! UpcomingCell

                cell.update(with: showOverview)
                return cell
            }
        )
    }

    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private lazy var delegate = makeDelegate()

    var data: [ShowOverview] = []
    
    // MARK: Properties

    let header = UpcomingTableHeader()
    weak var tappedCell: UpcomingCell?
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeDelegate() -> UICollectionViewDelegate {
        return UpcomingShowsCollectionViewDataDelegate(self, dataSource: dataSource)
    }

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: screenWidth, height: 500)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(light)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(UpcomingCell.self, forCellWithReuseIdentifier: UpcomingCell.identifier)
        return cv
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(light)
        transitioningDelegate = self

        collectionView.delegate = delegate
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: Internal methods

    func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<UpcomingSection, ShowOverview>()
        snapshot.appendSections(UpcomingSection.allCases)
        snapshot.appendItems(data, toSection: .tvShows)

        dataSource.apply(snapshot)
    }
    
    func update(withShow show: ShowOverview) {
        data.append(show)
        updateSnapShot()
    }

    func didTapCard(_ episodeCell: UpcomingCell, _ episode: Episode, _ show: ShowOverview) {
        let episodeScreen = UpcomingDetailedScreen()
        episodeScreen.transitioningDelegate = self
        episodeScreen.update(show: show, episode: episode)
        self.tappedCell = episodeCell

        episodeScreen.modalPresentationStyle = .overCurrentContext
        present(episodeScreen, animated: true, completion: nil)
    }
}


extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
