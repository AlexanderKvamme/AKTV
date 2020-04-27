//
//  UpcomingShowCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class UpcomingShowCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "UpcomingShowCell"
    
    private let backgroundImage = UIView()
    private let headerLabel = UILabel()
    
    // MARK: Initializers
    
    init() {
        super.init(style: .default, reuseIdentifier: UpcomingShowCell.identifier)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        headerLabel.text = "Header"
        headerLabel.sizeToFit()
        headerLabel.backgroundColor = .purple
        backgroundImage.backgroundColor = .green
    }
    
    private func addSubviewsAndConstraints() {
        [backgroundImage, headerLabel].forEach{ contentView.addSubview($0) }
        
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(withShow show: Show) {
        fatalError("bam would update cell with this: \(show)")
        
    }
}
