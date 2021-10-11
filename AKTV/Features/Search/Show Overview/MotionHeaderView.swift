//
//  ShowHeaderView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import ComplimentaryGradientView
import AVKit


enum MotionType {
    case movie
    case tvShow
}


final class MotionHeaderView: UIView {

    // MARK: Properties

    var titleLabel = BottomAlignedLabel()
    var showOverview: ShowOverview?
    var movie: Movie?
    let imageView = UIImageView()
    let gradientBackground = DiagonalComplimentaryView()
    let iconRow = IconRowView()
    let showStatusView = ShowStatusView()

    // MARK: Initializers

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

        setup()
        addSubviewsAndConstraints()
        addGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        backgroundColor = UIColor(light)

        imageView.contentMode = .scaleAspectFill

        titleLabel.textColor = UIColor(light)
        titleLabel.font = UIFont.gilroy(.heavy, 40)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0

        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true

        gradientBackground.gradientType = .colors(start: .primary, end: .secondary)
    }

    private func addGestureRecognizers() {
        iconRow.descriptionButton.addTarget(self, action: #selector(displayShowDescription), for: .touchUpInside)
        iconRow.trailersButton.addTarget(self, action: #selector(displayTrailer), for: .touchUpInside)
    }

    @objc private func displayShowDescription() {
        let vc = BasicTextDisplayerViewController()
        vc.episodeHeader.text = "ABOUT"
        vc.episodeTextView.text = showOverview?.overview
        findViewController()?.present(vc, animated: true, completion: nil)
    }

    @objc private func displayTrailer() {
        if showOverview != nil {
            displayShowTrailer()
        } else {
            displayMovieTrailer()
        }
    }

    private func displayShowTrailer() {
        guard let videos = showOverview?.videos,
              let firstResult = videos.results?.first,
              let key = firstResult.key else {
                  print("Could not display trailer due to missing info")
            return
        }

        if videos.results?.count ?? 0 > 1 {
            print("Multiple trailers/teasers received but not handled")
        }

        // TODO: Handle multiple videos for example multiple trailers/teasers
        guard let trailerUrl = URL(string: "https://www.youtube.com/watch?v=" + key) else {
            print("bad video url")
            return
        }

        let videoPlayer = VideoPlayer(trailerUrl)
        findViewController()?.present(videoPlayer, animated: true, completion: nil)
    }

    private func displayMovieTrailer() {
        guard let videoResults = movie?.videos?.results else {
            print("no videos to display")
            return
        }

        guard let vr = videoResults.first(where: { vr in
            let type = vr.type ?? "NO TYPE"
            return type == VideoResult.Keys.trailer.rawValue
        }) else {
            fatalError()
        }

        guard let key = vr.key else {
            print("no trailer key")
            return
        }

        if let trailerUrl = URL(string: "https://www.youtube.com/watch?v=" + key) {
            let videoPlayer = VideoPlayer(trailerUrl)
            findViewController()?.present(videoPlayer, animated: true, completion: nil)
        }
    }

    var currentType: MotionType {
        if showOverview != nil {
            return .tvShow
        } else if movie != nil {
            return .movie
        } else {
            fatalError()
        }
    }

    private func isFavorite() -> Bool {
        switch currentType {
        case .movie:
            let favMovies = UserProfileManager().favouriteMovies()
            let id = movie!.getId()
            return favMovies.contains(id)
        case .tvShow:
            let favShows = UserProfileManager().favouriteShows()
            let id = showOverview!.getId()
            return favShows.contains(id)
        }
    }

    private func addSubviewsAndConstraints() {
        addSubview(gradientBackground)
        addSubview(iconRow)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(showStatusView)

        gradientBackground.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom)
        }

        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.width.equalTo(screenWidth-48)
            make.height.equalTo(300)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView).inset(32)
        }

        iconRow.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(100)
        }

        showStatusView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(iconRow.snp.bottom)
            make.height.equalTo(46)
        }

        clipsToBounds = true
        
        snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.bottom.equalTo(showStatusView.snp.bottom)
        }
    }

    func update(withMovie movie: Movie) {
        self.movie = movie

        titleLabel.text = movie.name.uppercased()

        if let imagePath = movie.backdropPath,
           let url = URL(string: APIDAO.imdbImageRoot+imagePath) {

            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.gradientBackground.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        iconRow.update(with: movie)
        // TODO: Implement this for movie
//        showStatusView.update(with: showOverview)
    }

    func update(withShow showOverview: ShowOverview) {
        self.showOverview = showOverview

        titleLabel.text = showOverview.name.uppercased()

        if let imagePath = showOverview.backdropPath,
           let url = URL(string: APIDAO.imdbImageRoot+imagePath) {

            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.gradientBackground.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        iconRow.update(with: showOverview)
        showStatusView.update(with: showOverview)
    }
}
