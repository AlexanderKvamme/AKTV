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
        layer.cornerCurve = .continuous
        layer.cornerRadius = style.cornerRadius

//        let bv = UIView()
//        bv.backgroundColor = UIColor(dark)
//        bv.layer.cornerRadius = style.cornerRadius
//        selectedBackgroundView = bv
    }

    private func addSubviewsAndConstraints() {
        addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func getEpisode() -> Episode? {
        return currentEpisode
    }

    func configure(for cellState: CellState, upcomingEpisodes: [Episode]) {
        print("bam checking if self is a date from upcoming: ", upcomingEpisodes)
        dateLabel.text = cellState.text

        let episodeDates = upcomingEpisodes.compactMap({ $0.getFormattedDate() })

        // TODO: Multiple episodes on one day
        let matchingDate = episodeDates.first(where: { date in
            let isMatch = date == cellState.date
            print("bam isMatch: ", isMatch)
            return isMatch
        })

        if let matchingDate = matchingDate {
            let matchingEpisode = upcomingEpisodes.first { episode in
                episode.getFormattedDate() == matchingDate
            }
            currentEpisode = matchingEpisode
            print("matching episode: ", matchingEpisode)
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
