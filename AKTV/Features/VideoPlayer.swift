//
//  VideoPlayer.swift
//  AKTV
//
//  Created by Alexander Kvamme on 16/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import YouTubePlayer

final class VideoPlayer: UIViewController {

    // MARK: - Properties

    private let url: URL
    private let videoPlayer = YouTubePlayerView(frame: screenFrame)

    // MARK: - Initializers

    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .black

        videoPlayer.loadVideoURL(self.url)
        videoPlayer.delegate = self

        view.addSubview(videoPlayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoPlayer: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if [YouTubePlayerState.Ended, YouTubePlayerState.Paused].contains(playerState) {
            dismiss(animated: true, completion: nil)
        }
    }
}
