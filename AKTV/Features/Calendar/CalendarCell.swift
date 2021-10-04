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
import IGDB_SWIFT_API


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

    func setSelected(_ b: Bool) {
        backgroundColor = b ? UIColor(dark).withAlphaComponent(0.075) : .clear
    }

    func resetStyle(_ cellState: CellState) {
        dateLabel.text = cellState.text
        background.backgroundColor = .clear
        dateLabel.textColor = UIColor(dark)
        background.layer.cornerRadius = style.cornerRadius
        background.removeExternalBorders()
        backgroundColor = .clear

        // Fade months outside of current
        let isCurrentMonth = cellState.dateBelongsTo == .thisMonth
        switch isCurrentMonth {
        case true:
            dateLabel.alpha = 0.3
        case false:
            dateLabel.alpha = 0.1
        }
    }

    func setIsTodayStyle(cellState: CellState) {
        let formatter = DateFormatter.withoutTime
        let isToday = formatter.string(from: Date()) == formatter.string(from: cellState.date)
        let isThisMonth = cellState.dateBelongsTo == .thisMonth

        // Highlight today
        if isToday && isThisMonth {
            dateLabel.font = UIFont.gilroy(.semibold, dateLabel.font.pointSize)
            background.addExternalBorder(borderWidth: 3, borderColor: UIColor(dark))
        }
    }

    func configure(for cellState: CellState, episode: Episode, overview: ShowOverview) {
        resetStyle(cellState)

        // TODO: Multiple episodes on one day
        if cellState.dateBelongsTo == .thisMonth {
            updateCellDesign(for: episode, overview, cellState: cellState)
        }
        setIsTodayStyle(cellState: cellState)
    }

    // Skal jeg overloade med en egen metode for games?
    // Eller subclasse

    func configure(for cellState: CellState, game: Proto_Game) {
        resetStyle(cellState)

        // TODO: Multiple episodes on one day
        if cellState.dateBelongsTo == .thisMonth {
            updateCellDesign(for: game, cellState: cellState)
        }

        setIsTodayStyle(cellState: cellState)
    }

    override func prepareForReuse() {
        dateLabel.textColor = UIColor(dark)
    }

    private func updateCellDesign(for game: Proto_Game, cellState: CellState) {
        // Basic "date has episode" styles
        dateLabel.textColor = UIColor(light)
        dateLabel.alpha = 0.6
        dateLabel.textColor = .green

        // FIXME: MOVE THIS AWAY. gonna try to get a cover object instead

        if let existingColors = ColorStore.get(colorsFrom: game) {
            background.backgroundColor = existingColors.detail
            dateLabel.textColor = existingColors.background
        } else {
            GameService.fetchCoverImageUrl(cover: game.cover) { coverImageUrl in
                DispatchQueue.main.async {
                    UIImageView().kf.setImage(with: coverImageUrl, completionHandler: { result in
                        do {
                            let unwrappedResult = try result.get()
                            unwrappedResult.image.getColors { (colors) in
                                ColorStore.save(colors, forGame: game)
                                self.updateCellDesign(for: game, cellState: cellState)
                            }
                        } catch {
                            print("Error: while retrieving image from stillPath")
                        }
                    })
                }
            }
        }
    }

    private func updateCellDesign(for episode: Episode, _ overview: ShowOverview, cellState: CellState) {
        // Basic "date has episode" styles
        dateLabel.textColor = UIColor(light)
        dateLabel.alpha = 0.6

        guard let stillPath = overview.posterPath else { return }

        if let existingColors = ColorStore.get(colorsFrom: overview) {
            background.backgroundColor = existingColors.detail
            dateLabel.textColor = existingColors.background
        } else {
            DispatchQueue.main.async {
                UIImageView().kf.setImage(with: URL(string: APIDAO.imdbImageRoot+stillPath), completionHandler: { result in
                    do {
                        let unwrappedResult = try result.get()
                        unwrappedResult.image.getColors { (colors) in
                            ColorStore.save(colors, forOverview: overview)
                            self.updateCellDesign(for: episode, overview, cellState: cellState)
                        }
                    } catch {
                        print("Error: while retrieving image from stillPath")
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

// TODO: MOVE ME

extension UIView {

    struct Constants {
        static let ExternalBorderName = "externalBorder"
    }

    @discardableResult func addExternalBorder(borderWidth: CGFloat = 2.0, borderColor: UIColor = UIColor.white) -> CALayer {
        let externalBorder = CALayer()
        externalBorder.cornerRadius = frame.size.height/2
        externalBorder.frame = CGRect(x: -borderWidth, y: -borderWidth, width: frame.size.width + 2 * borderWidth, height: frame.size.height + 2 * borderWidth)
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = Constants.ExternalBorderName

        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false

        return externalBorder
    }

    func removeExternalBorders() {
        layer.sublayers?.filter() { $0.name == Constants.ExternalBorderName }.forEach() {
            $0.removeFromSuperlayer()
        }
    }

    func removeExternalBorder(externalBorder: CALayer) {
        guard externalBorder.name == Constants.ExternalBorderName else { return }
        externalBorder.removeFromSuperlayer()
    }

}
