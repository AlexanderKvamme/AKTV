//
//  UpcomingShowCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftUI

final class UpcomingShowCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "UpcomingShowCell"

    let hostView = UIHostingController(rootView: UpcomingShowCellView())
    
    // MARK: Initializers
    
    init() {
        super.init(style: .default, reuseIdentifier: UpcomingShowCell.identifier)

        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func addSubviewsAndConstraints() {
        [hostView.view].forEach{ contentView.addSubview($0) }

        hostView.view.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Internal methods
    
    func update(withShowOverview showOverview: ShowOverview) {
        // TODO: Fetch from tv
        // TODO: Update header and data
        let url = URL(string: "https://smp.vgc.no/v2/images/e2b9a0f6-526b-4615-850e-bd38fc8e4d20?fit=crop&h=1267&w=1900&s=7ec50dd6a79a0dda0596386dd5768008510fccfa")
//        showImageView.kf.setImage(with: url)
    }
}
