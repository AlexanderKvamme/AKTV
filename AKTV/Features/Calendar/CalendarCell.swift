//
//  CalendarCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 20/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Kingfisher
import Just


fileprivate struct style {
    static let cornerRadius: CGFloat = 8
}


class CalendarCell: JTACDayCell {

    let dateLabel = UILabel()
    let background = UIView()

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
            make.edges.equalToSuperview().inset(4)
        }
    }

    func resetStyle(_ cellState: CellState) {
        dateLabel.text = cellState.text
        background.backgroundColor = .clear
        dateLabel.textColor = UIColor(dark)

        // Fade months outside of current
        let isCurrentMonth = cellState.dateBelongsTo == .thisMonth
        switch isCurrentMonth {
        case true:
            dateLabel.alpha = 0.3
        case false:
            dateLabel.alpha = 0.1
        }
    }

    func configure(for cellState: CellState, episode: Episode, overview: ShowOverview) {
        resetStyle(cellState)

        // TODO: Multiple episodes on one day

        if cellState.dateBelongsTo == .thisMonth {
            updateCellDesign(for: episode, overview, cellState: cellState)
        }
    }

    override func prepareForReuse() {
        dateLabel.textColor = UIColor(dark)
    }

    private func updateCellDesign(for episode: Episode, _ overview: ShowOverview, cellState: CellState) {
        let formatter = DateFormatter.withoutTime
        let isToday = formatter.string(from: Date()) == formatter.string(from: cellState.date)

        // Basic "date has episode" styles
        background.backgroundColor = UIColor(dark)
        dateLabel.textColor = UIColor(light)
        dateLabel.alpha = 1

        // Highlight today
        if isToday {
            background.layer.cornerRadius = background.frame.width/2
            background.backgroundColor = .red
            return
        }

        guard let stillPath = overview.posterPath else { return }

        if let existingColors = ColorStore.get(colorsFrom: overview) {
            background.backgroundColor = existingColors.secondary
        } else {
            DispatchQueue.main.async {
                UIImageView().kf.setImage(with: URL(string: APIDAO.imageRoot+stillPath), completionHandler: { result in
                    do {
                        let unwrappedResult = try result.get()
                        unwrappedResult.image.getColors { (colors) in
                            ColorStore.save(colors, forOverview: overview)
                            self.updateCellDesign(for: episode, overview, cellState: cellState)
                        }
                    } catch {
                        print("bam had error while retrieving image from stillPath")
                    }
                })
            }
        }

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
