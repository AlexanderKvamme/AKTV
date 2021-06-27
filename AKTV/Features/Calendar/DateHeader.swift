//
//  DateHeader.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateHeader: JTACMonthReusableView {

    var monthLabel = UILabel.make(.header)
    var yearLabel = UILabel.make(.subtitle)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        monthLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        monthLabel.text = "January"
        monthLabel.textColor = UIColor(dark)
        monthLabel.font = UIFont.round(.bold, 24)
        monthLabel.sizeToFit()

        yearLabel.text = "2021"
        yearLabel.textColor = UIColor(dark)
        yearLabel.font = UIFont.round(.light, 24)
        yearLabel.alpha = 0.4
    }

    private func addSubviewsAndConstraints() {
        addSubview(monthLabel)
        addSubview(yearLabel)

        monthLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(monthLabel)
            make.left.equalTo(monthLabel.snp.right).offset(8)
            make.right.equalToSuperview()
        }
    }

}
