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

    var dayStack: UIStackView!
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
        dayStack = makeDayStack()
        monthLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        monthLabel.text = "January"
        monthLabel.textColor = UIColor(dark)
        monthLabel.font = UIFont.round(.bold, 30)
        monthLabel.sizeToFit()
        monthLabel.clipsToBounds = false

        yearLabel.text = "2021"
        yearLabel.textColor = UIColor(dark)
        yearLabel.font = UIFont.round(.light, 30)
        yearLabel.alpha = 0.4
    }

    private func addSubviewsAndConstraints() {
        addSubview(monthLabel)
        addSubview(yearLabel)
        addSubview(dayStack)

        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(dayStack)
            make.bottom.equalTo(dayStack.snp.top)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(monthLabel)
            make.left.equalTo(monthLabel.snp.right).offset(8)
            make.right.equalToSuperview()
        }

        dayStack.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(monthLabel.snp.bottom)
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    private func makeDayStack() -> UIStackView {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalCentering

        let dayLabels = days.map{ (str) -> UILabel in
            let lbl = UILabel()
            lbl.font = UIFont.round(.bold, 20)
            lbl.text = str
            lbl.textColor = UIColor(dark)
            return lbl
        }

        dayLabels.forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }

}
