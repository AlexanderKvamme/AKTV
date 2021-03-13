//
//  UpcomingScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit


extension UpcomingScreen: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let cell = tappedCell else { return nil }

        return UpcomingToDetailedAnimationController(cell)
    }
}


final class UpcomingScreen: UIViewController {
    
    // MARK: Properties

    var collectionView: UICollectionView
    var dataDelegate: UpcomingShowsCollectionViewDataDelegate!
    let header = UpcomingTableHeader()

    weak var tappedCell: UpcomingCell?
    
    // MARK: Initializers
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        transitioningDelegate = self

        self.dataDelegate = UpcomingShowsCollectionViewDataDelegate(self)

        collectionView.dataSource = dataDelegate
        collectionView.delegate = dataDelegate
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UpcomingCell.self, forCellWithReuseIdentifier: UpcomingCell.identifier)

        collectionView.backgroundColor = UIColor(light)
        view.backgroundColor = UIColor(light)
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(header)

        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(142)
        }

        view.addSubview(collectionView)
        collectionView.clipsToBounds = true
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: Internal methods
    
    func update(withShows shows: [ShowOverview]) {
        print("bam updating with multiple")
        dataDelegate.update(withShows: shows)
        collectionView.reloadData()
    }
    
    func update(withShow show: ShowOverview) {
        dataDelegate.update(withShow: show)

        // FIXME: remove this later
        collectionView.reloadData()
    }

    func didTapCard(_ episodeCell: UpcomingCell, _ episode: Episode) {
        let episodeScreen = EpisodeScreen2()
        episodeScreen.transitioningDelegate = self
        episodeScreen.update(show: ShowOverview.mock, episode: Episode.mock)
        self.tappedCell = episodeCell

        episodeScreen.modalPresentationStyle = .fullScreen
        present(episodeScreen, animated: true, completion: nil)
    }
}


extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}
