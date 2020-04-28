//
//  UpcomingTableHeader.swift
//  AKTV
//
//  Created by Alexander Kvamme on 28/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class UpcomingTableHeader: UIView {
    
    // MARK: Properties
    
    let headerLabel = UILabel()
    let testView = UIView()
    
    // MARK: Initializers
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .orange
        headerLabel.text = "Upcoming shows"
        headerLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
}
