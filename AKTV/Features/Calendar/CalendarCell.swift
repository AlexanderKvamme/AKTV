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

extension Array where Element == Episode {

    func filterUniqueShows() -> [Episode] {
        var filtered = [Episode]()

        for episode in self {
            let showId = episode.showId
            if filtered.first(where: { $0.showId == showId }) == nil {
                filtered.append(episode)
            }
        }

        return filtered
    }
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

    func applyIsTodayStyle(cellState: CellState) {
        let formatter = DateFormatter.withoutTime
        let isToday = formatter.string(from: Date()) == formatter.string(from: cellState.date)
        let isThisMonth = cellState.dateBelongsTo == .thisMonth

        // Highlight today
        if isToday && isThisMonth {
            dateLabel.font = UIFont.gilroy(.semibold, dateLabel.font.pointSize)
            background.addExternalBorder(borderWidth: 3, borderColor: UIColor(dark))
        }
    }

    func configure(for cellState: CellState, entities: [Entity]) {
        if cellState.dateBelongsTo == .thisMonth {
            updateCellDesign(for: entities, cellState: cellState)
        }

        applyIsTodayStyle(cellState: cellState)
    }

    override func prepareForReuse() {
        dateLabel.textColor = UIColor(dark)
    }

    private func styleCellForMultipleEpisodes() {
        background.backgroundColor = .black
        dateLabel.textColor = UIColor(light)
        dateLabel.alpha = 1
    }

    private func updateCellDesign(for entities: [Entity], cellState: CellState) {
        resetStyle(cellState)

        if entities.count == 1 {
            guard let firstEntity = entities.first else { fatalError() }

            if let game = firstEntity as? Proto_Game {
                applyStyle(for: game, cellState: cellState)
            } else if let movie = firstEntity as? Movie {
                applyStyle(for: movie, cellState: cellState)
            } else if let show = firstEntity as? Episode {
                // FIXME: Denne er feil

                applyStyle(for: show, cellState: cellState)
            } else {
                assertionFailure("Should not occur")
            }

            return
        } else {
            styleCellForMultipleEpisodes()
        }
    }

    // FIXME: These recursive calles could be slow even with cache
    // Episode
    private func applyStyle(for episode: Episode, cellState: CellState) {
        guard let showId = episode.showId else { return }

        if let existingColors = ColorStore.getMovieDBColors(from: episode.showId!) {
            DispatchQueue.main.async {
                self.background.backgroundColor = existingColors.detail
                self.dateLabel.textColor = existingColors.background
            }
        } else {
            APIDAO().show(withId: showId) { show in
                guard let posterPath = show.posterPath else { return }

                DispatchQueue.main.async {
                    UIImageView().kf.setImage(with: URL(string: APIDAO.imdbImageRoot+posterPath), completionHandler: { result in
                        do {
                            let unwrappedResult = try result.get()
                            unwrappedResult.image.getColors { (colors) in
                                ColorStore.save(colors, id: Int(show.id))
                                self.applyStyle(for: episode, cellState: cellState)
                            }
                        } catch {
                            print("Error: while retrieving image from stillPath")
                        }
                    })
                }
            }
        }
    }

    // Movie
    private func applyStyle(for movie: Movie, cellState: CellState) {
        guard let stillPath = movie.posterPath else { return }

        if let existingColors = ColorStore.get(colorsFrom: movie) {
            background.backgroundColor = existingColors.detail
            dateLabel.textColor = existingColors.background
        } else {
            DispatchQueue.main.async {
                UIImageView().kf.setImage(with: URL(string: APIDAO.imdbImageRoot+stillPath), completionHandler: { result in
                    do {
                        let unwrappedResult = try result.get()
                        unwrappedResult.image.getColors { (colors) in
                            ColorStore.save(colors, forMovie: movie)
                            self.applyStyle(for: movie, cellState: cellState)
                        }
                    } catch {
                        print("Error: while retrieving image from stillPath")
                    }
                })
            }
        }
    }

    // Game
    private func applyStyle(for game: Proto_Game, cellState: CellState) {
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
                                self.applyStyle(for: game, cellState: cellState)
                            }
                        } catch {
                            print("Error: while retrieving image from stillPath")
                        }
                    })
                }
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
