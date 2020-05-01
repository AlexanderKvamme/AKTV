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
    private let dateLabel = UILabel()
    
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
        headerLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        headerLabel.text = "Header"
        headerLabel.backgroundColor = .purple
        backgroundImage.backgroundColor = .green
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        dateLabel.text = "01.01.01"
    }
    
    private func addSubviewsAndConstraints() {
        [backgroundImage, headerLabel, dateLabel].forEach{ contentView.addSubview($0) }
        
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerLabel)
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
    }
    
    // MARK: Internal methods
    
    func update(withShowOverview showOverview: ShowOverview) {
        headerLabel.text = "\(showOverview.id)"
        
        // Date
        guard let date = showOverview.nextEpisodeToAir else {
            dateLabel.text = "No date"
            return
        }
        
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let stringDate = formatter1.string(from: date)
        dateLabel.text = stringDate
    }
}
