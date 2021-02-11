//
//  EpisodeCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SnapKit

final class EpisodeCell: UITableViewCell {

    // MARK: Properties

    static let identifier = "Episode Cell"

    let episodeNumberLabel = UILabel()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let labelStack = UIStackView()

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: EpisodeCell.identifier)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear

        episodeNumberLabel.font = UIFont.round(.bold, 40)
        episodeNumberLabel.alpha = 0.3
        episodeNumberLabel.textColor = UIColor(light)
        episodeNumberLabel.textAlignment = .center

        dateLabel.textColor = UIColor(light)
        dateLabel.font = UIFont.gilroy(.semibold, 16)
        dateLabel.alpha = 0.5

        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        nameLabel.textColor = UIColor(light)
        nameLabel.font = UIFont.gilroy(.semibold, 20)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

        labelStack.axis = .vertical
        labelStack.spacing = 4

        labelStack.addArrangedSubview(dateLabel)
        labelStack.addArrangedSubview(nameLabel)
    }

    private func addSubviewsAndConstraints() {
        contentView.addSubview(episodeNumberLabel)
        contentView.addSubview(labelStack)

        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }

        episodeNumberLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }

        labelStack.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(episodeNumberLabel.snp.right)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: Internal methods

    func update(with episode: Episode) {
        episodeNumberLabel.text = "\(episode.episodeNumber)"
        nameLabel.text = episode.name
        nameLabel.sizeToFit()
        dateLabel.text = episode.airDate
    }
}
