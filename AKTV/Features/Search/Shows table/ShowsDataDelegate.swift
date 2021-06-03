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

    static let estimatedHeight: CGFloat = 64
    var header = UILabel()
    
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

        header.text = "Shazam"
        header.textColor = UIColor(dark)
        header.font = UIFont.gilroy(.bold, 20)
        header.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        header.backgroundColor = .clear
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(header)
        
        header.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(24)

            make.height.equalTo(Self.estimatedHeight)
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(with show: Show) {
        header.text = show.name
    }
}
