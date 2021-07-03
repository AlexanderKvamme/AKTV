//
//  EpisodesSearchResultDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

final class ShowCell: UITableViewCell {
    
    // MARK: Properties

    static let estimatedHeight: CGFloat = 80
    let iconImageView = UIImageView()
    let labelStack = UIStackView()
    var header = UILabel()
    var subheader = UILabel()
    var card = Card(radius: 16)

    // MARK: Initializers
    
    static let identifier = "EpisodeCell"
    
    init(for episode: Show) {
        super.init(style: .default, reuseIdentifier: ShowCell.identifier)

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

        header.textColor = UIColor(dark)
        header.font = UIFont.gilroy(.bold, 18)
        header.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        header.adjustsFontSizeToFitWidth = true
        header.numberOfLines = 2

        subheader.text = "Televison, 2021"
        subheader.textColor = UIColor(dark)
        subheader.font = UIFont.gilroy(.regular, 14)
        subheader.alpha = 0.4
        subheader.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)

        labelStack.axis = .vertical
        labelStack.distribution = UIStackView.Distribution.fill
        labelStack.alignment = .leading

        let img = UIImage(systemName: "film")?.withTintColor(.red, renderingMode: .alwaysTemplate)
        iconImageView.image = img
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(dark)
    }
    
    private func addSubviewsAndConstraints() {
        labelStack.addArrangedSubview(header)
        labelStack.addArrangedSubview(subheader)

        contentView.addSubview(card)
        contentView.addSubview(labelStack)
        contentView.addSubview(iconImageView)

        card.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(24)
        }

        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(card).inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        labelStack.snp.makeConstraints { make in
            make.centerY.equalTo(card)
            make.right.equalTo(card).offset(-16)
            make.left.equalTo(iconImageView.snp.right).offset(24)
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(with show: Show) {
        header.text = show.name
    }
}
