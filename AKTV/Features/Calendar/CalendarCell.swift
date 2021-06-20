//
//  CalendarCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 20/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarCell: JTACDayCell {

    let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        dateLabel.text = "9"
        dateLabel.textColor = UIColor(dark)
        dateLabel.font = UIFont.gilroy(.medium, 18)
        dateLabel.textAlignment = .center
    }

    private func addSubviewsAndConstraints() {
        addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for cellState: CellState) {
        dateLabel.text = cellState.text

        if cellState.date.get(.day) == 13 {
            backgroundColor = .green
        }

        switch cellState.dateBelongsTo {
        case .thisMonth:
            dateLabel.alpha = 0.3
        default:
            dateLabel.alpha = 0.1
        }
    }

    override func prepareForReuse() {
        dateLabel.textColor = UIColor(dark)
        backgroundColor = .clear
    }
}

// TODO: MOVE ME

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
