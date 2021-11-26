//
//  CalendarScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 20/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SnapKit
import SwiftUI
import IGDB_SWIFT_API

protocol Entity {
    var id: UInt64 { get }
    var name: String { get }
    func getMainGraphicsURL() -> URL?
}

enum EntityType {
    case movie
    case game
    case tvShow
}

extension Entity {
    var type: EntityType {
        switch self {
        case _ as Episode:
            return .tvShow
        case _ as Movie:
            return .movie
        case _ as Proto_Game:
            return .game
        default:
            fatalError()
        }
    }

    func graphicsPath() -> String? {

        switch self {
        case let episode as Episode:
            return episode.artPath

        case let movie as Movie:
            return movie.posterPath
        case let game as Proto_Game:
            return game.cover.url
        default:
            assertionFailure("New type, who dis?")
            return "Not handled"
        }

    }
}

extension Proto_Game: Identifiable {    }

// Get Path
extension Proto_Game: Entity {
    func getMainGraphicsURL() -> URL? {
        let urlString = cover.url.dropFirst().dropFirst()
        let replacedSize = urlString.replacingOccurrences(of: "t_thumb", with: "t_cover_big")
        return URL(string: "https:" + replacedSize)
    }
}

extension Episode: Entity {
    func getMainGraphicsURL() -> URL? {
        let root = "https://image.tmdb.org/t/p/original/"
        guard let path = artPath else { return nil }
        
        return URL(string: root + path)
    }
}

extension Show: Entity {
    func getMainGraphicsURL() -> URL? {
        let root = "https://image.tmdb.org/t/p/original/"
        guard let path = posterPath else { return nil }
        
        return URL(string: root + path)
    }
}

extension Movie: Entity {
    func getMainGraphicsURL() -> URL? {
        let root = "https://image.tmdb.org/t/p/original/"
        guard let path = posterPath else { return nil }
        
        return URL(string: root + path)
    }
}

fileprivate struct style {
    static let calendarHeaderHeight: CGFloat        = 80
    static let calendarHorizontalOffset: CGFloat    = 32
    static let calendarHeight: CGFloat              = 190 + calendarHeaderHeight
    static let calendarBottomOffset: CGFloat        = 100

    static let cardHorizontals: CGFloat             = 24

    static let cornerRadius: CGFloat                = 5
}

final class CalendarScreen: UIViewController {

    // MARK: - Properties

    let dateFormatter = DateFormatter.withoutTime
    let chevronButton = UIImageView()
    let cv = JTACMonthView(frame: CGRect(x: style.calendarHorizontalOffset/2+style.cardHorizontals,
                                         y: screenHeight-style.calendarHeight-style.calendarBottomOffset,
                                         width: screenWidth-style.calendarHorizontalOffset-2*style.cardHorizontals,
                                         height: style.calendarHeight))
    var calendarCard = Card()
    var imageCard = ImageCard()
    var entityDict = [String : [Entity]]()
    var formatter = DateFormatter.withoutTime

    fileprivate var currentlySelectedEntities = [Entity]()

    weak var tabBar: CustomTabBarDelegate?

    // MARK: - Initializers

    init(tabBar: CustomTabBarDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.tabBar = tabBar

        view.backgroundColor = UIColor(light)

        setup()
        addSubviewsAndConstraints()

        addGestureToImageCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addGestureToImageCard() {
        let tr = UITapGestureRecognizer(target: self, action: #selector(presentDetailedScreen))
        self.imageCard.addGestureRecognizer(tr)
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPremiereDates()
    }

    // MARK: - Methods

    private func addEntityIfUnique(_ entity: Entity, toDateString str: String) {
        if let existing = self.entityDict[str] {
            var inclusive = existing
            inclusive.append(entity)
            self.entityDict[str] = inclusive
        } else {
            self.entityDict[str] = [entity]
        }

        reloadCalendarDate(str)
    }

    private func reloadCalendarDate(_ str: String) {
        let formatter = DateFormatter.withoutTime
        formatter.timeZone = TimeZone.init(abbreviation: "UTC")

        if let formattedDate = formatter.date(from: str) {
            cv.reloadDates([formattedDate])
        }
    }

    private func fetchPremiereDates() {
        let dao = APIDAO()
        let favShows = UserProfileManager().favouriteShows()
        let favMovies = UserProfileManager().favouriteMovies()
        let favGames = GameStore.getFavourites()

        favShows.forEach {
            dao.showOverview(withId: $0) { overview in
                dao.episodes(showId: overview.id, seasonNumber: overview.numberOfSeasons) { season in
                    DispatchQueue.main.async {
                        season.episodes.forEach { episode in
                            if let formattedDate = episode.getFormattedDate() {
                                let str = DateFormatter.withoutTime.string(from: formattedDate)
                                self.addEntityIfUnique(episode, toDateString: str)
                            }
                        }
                    }
                }
            }
        }

        favMovies.forEach {
            dao.movie(withId: UInt64($0)) { movie in
                if let formattedDate = movie.releaseDate {
                    DispatchQueue.main.async {
                        self.addEntityIfUnique(movie, toDateString: formattedDate)
                    }
                }
            }
        }

        favGames.forEach { gameId in
            dao.game(withId: UInt64(gameId)) { game in
                DispatchQueue.main.async {
                    // TODO: No idea why but this works :P
                    let dayString = DateFormatter.withoutTime.string(from: game.firstReleaseDate.date.addingTimeInterval(-60*60*24))
                    self.addEntityIfUnique(game, toDateString: dayString)
                }
            }
        }
    }

    private func setup() {
        let exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(exitScreen))
        chevronButton.addGestureRecognizer(exitTapGesture)
        chevronButton.isUserInteractionEnabled = true

        cv.backgroundColor = .clear
        cv.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        cv.calendarDelegate = self
        cv.calendarDataSource = self
        cv.minimumInteritemSpacing = 0
        cv.minimumLineSpacing = 0
        cv.scrollToDate(Date(), animateScroll: false)

        cv.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DateHeader")

        cv.allowsMultipleSelection = false

        cv.scrollDirection = .horizontal
        cv.scrollingMode = .stopAtEachCalendarFrame
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(calendarCard)
        view.addSubview(cv)
        view.addSubview(imageCard)
        view.addSubview(chevronButton)

        imageCard.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(calendarCard.snp.top).offset(-16)
        }

        calendarCard.snp.makeConstraints { make in
            make.top.equalTo(cv).offset(-24)
            make.left.right.equalTo(imageCard)
            make.bottom.equalTo(cv).offset(24)
        }

        let configuration = UIImage.SymbolConfiguration (pointSize: 24.0, weight: .light)
        chevronButton.image = UIImage(systemName: "chevron.down", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        chevronButton.tintColor = UIColor(dark).withAlphaComponent(0.1)

        chevronButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    @objc func exitScreen() {
        navigationController?.popToRootViewController(animated: true)
        tabBar?.showIt()
    }

}

extension CalendarScreen: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let day: TimeInterval = 60*60*24
        let month: TimeInterval = day*31
        let startDate = Date().addingTimeInterval(-3*month) // formatter.date(from: "2018 01 01")!
        let endDate = Date().addingTimeInterval(3*month)
        let config = ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        return config
    }
}


extension CalendarScreen: JTACMonthViewDelegate {

    // On selecting cell
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

        currentlySelectedEntities = []
        imageCard.reset()

        guard let cell = cell as? CalendarCell else { fatalError() }
        cell.setSelected(true)

        DispatchQueue.main.async {
            let key = DateFormatter.withoutTime.string(from: date)

            if let entities = self.entityDict[key] {
                entities.forEach { entity in
                    self.currentlySelectedEntities.append(entity)
                    
                    if let url = entity.getMainGraphicsURL() {
                        self.imageCard.addImage(url: url)
                    }
                }
            }
        }
    }

    // de-selected cell
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarCell else { return }
        cell.setSelected(false)
    }

    // willDisplay
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarCell else { fatalError() }

        cell.resetStyle(cellState)

        let key = DateFormatter.withoutTime.string(from: date)

        if let entities = entityDict[key] {
            cell.configure(for: cellState, entities: entities)
        }
    }

    // Use dataSource to make cells
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.resetStyle(cellState)

        let key = DateFormatter.withoutTime.string(from: date)
        if let entities = entityDict[key] {
            cell.configure(for: cellState, entities: entities)
        }

        return cell
    }

    // Header
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        formatter.dateFormat = "MMMM"

        guard let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as? DateHeader else {
            print("Error could not dequeue calendar header")
            return JTACMonthReusableView()
        }

        header.monthLabel.text = formatter.string(from: range.start)
        return header
    }

    @objc func presentDetailedScreen(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: imageCard)
        let segments = CGFloat(currentlySelectedEntities.count)
        let cardWidth = CGFloat(imageCard.frame.width)
        let normalized = location.x/cardWidth
        let tappedSegment = Int(normalized*segments)
        let tappedEntity = currentlySelectedEntities[tappedSegment]
        let entityScreen = SUDetailedEntity(entity: tappedEntity)
        let vc = UIHostingController(rootView: entityScreen)
        present(vc, animated: true)
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: style.calendarHeaderHeight)
    }
}

