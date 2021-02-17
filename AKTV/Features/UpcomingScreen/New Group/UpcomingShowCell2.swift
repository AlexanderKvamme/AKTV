//
//  UpcomingShowCell2.swift
//  AKTV
//
//  Created by Alexander Kvamme on 17/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SwiftUI


final class UpcomingShowCell2: UITableViewCell {

    // MARK: Properties

    static let identifier = "UpcomingShowCell2"

    let hostView = UIHostingController(rootView: UpcomingShowCellView2(title: "TITLE", imageURL: "https://example.com/image.png", day: "SOME DAY"))

    // MARK: Initializers

    init() {
        super.init(style: .default, reuseIdentifier: UpcomingShowCell2.identifier)

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
        let newCellView = UpcomingShowCellView2(title: showOverview.name, imageURL: showOverview.backdropPath, day: "Some day")
        hostView.rootView = newCellView
    }
}
