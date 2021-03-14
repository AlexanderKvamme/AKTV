//
//  EpisodeScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 24/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SnapKit


/// Adds on the basic superview controller by adding icons related to the episode it displays
final class EpisodeScreen: BasicTextDisplayerViewController {

    // MARK: - Properties

    private let episodeDetailsView: EpisodeDetailsView
    private let subtitle = UILabel.make(.subtitle)

    // MARK: - Initializers

    init(_ episode: Episode) {
        let calendarItem = LabeledIconButton(text: episode.airDate, icon: "calendar")
        let numberItem = LabeledIconButton(text: "\(episode.episodeNumber)", icon: "number")
        let listItem = LabeledIconButton(text: "List", icon: "rectangle.grid.1x2")
        let buttons = [calendarItem, numberItem, listItem]

        buttons.forEach({ $0.setIconAlpha(0.7) })

        self.episodeDetailsView = EpisodeDetailsView(for: episode, buttons: buttons)
        super.init()

        super.update(with: episode)


        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        subtitle.text = "Overview"
    }

    private func addSubviewsAndConstraints() {
        episodeTextView.snp.removeConstraints()

        view.addSubview(episodeDetailsView)
        episodeDetailsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(episodeHeader.snp.bottom).offset(24)
            make.height.equalTo(EpisodeDetailsView.height)
        }

        view.addSubview(subtitle)
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(episodeDetailsView.snp.bottom).offset(64)
            make.right.equalTo(episodeTextView)
            make.left.equalTo(episodeTextView).offset(4)
        }

        episodeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom).offset(8)
            make.left.right.equalTo(episodeHeader)
            make.bottom.equalToSuperview()
        }
    }
}
