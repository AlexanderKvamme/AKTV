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

    let hostView = UIHostingController(rootView: UpcomingShowCellView(ShowOverview.mock))
    
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
        let newCellView = UpcomingShowCellView(showOverview)
        hostView.rootView = newCellView
    }
}
