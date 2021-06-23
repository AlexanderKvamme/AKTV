//
//  CalendarCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 20/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import JTAppleCalendar


fileprivate struct style {
    static let cornerRadius: CGFloat = 5
}


class CalendarCell: JTACDayCell {

    let dateLabel = UILabel()
    let background = UIView()
    var currentEpisode: Episode?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 40))

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
        dateLabel.isUserInteractionEnabled = false

        background.layer.cornerCurve = .continuous
        background.layer.cornerRadius = style.cornerRadius
    }

    private func addSubviewsAndConstraints() {
        addSubview(background)
        addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.right.bottom.equalToSuperview()
        }

        background.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
        }
    }

    func getEpisode() -> Episode? {
        return currentEpisode
    }

    private func resetStyle() {
        background.backgroundColor = .clear
        dateLabel.textColor = UIColor(dark)
    }

    func configure(for cellState: CellState, upcomingEpisodes: [Episode]) {
        resetStyle()

        switch cellState.dateBelongsTo {
        case .thisMonth:
            dateLabel.alpha = 0.3
        default:
            dateLabel.alpha = 0.1
        }

        print("bam checking if self is a date from upcoming: ", upcomingEpisodes)

        dateLabel.text = cellState.text

        let episodeDates = upcomingEpisodes.compactMap({ $0.getFormattedDate() })

        // TODO: Multiple episodes on one day
        let matchingDate = episodeDates.first(where: { date in
            let isMatch = date == cellState.date
            print("bam isMatch: ", isMatch)
            if isMatch {
                background.backgroundColor = UIColor(dark)
                dateLabel.textColor = UIColor(light)
                        dateLabel.alpha = 1
            }
            return isMatch
        })

        if let matchingDate = matchingDate {
            let matchingEpisode = upcomingEpisodes.first { episode in
                episode.getFormattedDate() == matchingDate
            }
            currentEpisode = matchingEpisode
            print("matching episode: ", matchingEpisode)
        }

    }

    override func prepareForReuse() {
        dateLabel.textColor = UIColor(dark)
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
