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
        
        backgroundColor = UIColor(light)
        headerLabel.text = "Upcoming shows"
        headerLabel.font = UIFont.round(DINWeights.black, 40)
        headerLabel.textAlignment = .center
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
