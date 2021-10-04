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
import IGDB_SWIFT_API


extension DateFormatter {
    static var withoutTime: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyy-MM-dd"
        return df
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

    let chevronButton = UIImageView()
    let cv = JTACMonthView(frame: CGRect(x: style.calendarHorizontalOffset/2+style.cardHorizontals,
                                         y: screenHeight-style.calendarHeight-style.calendarBottomOffset,
                                         width: screenWidth-style.calendarHorizontalOffset-2*style.cardHorizontals,
                                         height: style.calendarHeight))
    var calendarCard = Card()
    var imageCard = ImageCard()
    var episodeDict = [String : (Episode, ShowOverview)]()
    var gameDict = [String: Proto_Game]()
    var formatter = DateFormatter.withoutTime
    var upcomingShows = [Episode]() {
        didSet {
            DispatchQueue.main.async {
                // TODO: Move these methods to a addEpisode and reload that date only
                // Same for games
                let datesAdded = self.upcomingShows.compactMap{ $0.getFormattedDate() }
                self.cv.reloadDates(datesAdded)
            }
        }
    }
    var upcomingGames = [Proto_Game]() {
        didSet {
            DispatchQueue.main.async {
                let datesAdded = self.upcomingGames.compactMap{ $0.firstReleaseDate.date }.sorted()
                self.cv.reloadDates(datesAdded)
            }
        }
    }

    fileprivate var currentlySelectedGame: Proto_Game?

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
        let tr = UITapGestureRecognizer(target: self, action: #selector(presentGameScreen))
        self.imageCard.addGestureRecognizer(tr)
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPremiereDates()
    }

    // MARK: - Methods

    private func fetchPremiereDates() {
        let dao = APIDAO()
        let favShows = UserProfileManager().favouriteShows()
        let favGames = GameStore.getFavourites()
        print("favShowS: ", favShows)
        print("favGames: ", favGames)

        favShows.forEach {
            dao.show(withId: $0) { overview in
                dao.episodes(showId: overview.id, seasonNumber: overview.numberOfSeasons) { season in
                    DispatchQueue.main.async {
                        season.episodes.forEach { episode in
                            if let formattedDate = episode.getFormattedDate() {
                                let str = DateFormatter.withSimplifiedDayStyle.string(from: formattedDate)

                                // FIXME: Should allow for multiple episodes on one day
                                self.episodeDict[str] = (episode, overview)
                                self.upcomingShows.append(episode)
                            }
                        }
                    }
                }
            }
        }

        favGames.forEach { gameId in
            dao.game(withId: UInt64(gameId)) { game in
                // TODO: No idea why but this works :P
                let dayString = DateFormatter.withSimplifiedDayStyle.string(from: game.firstReleaseDate.date.addingTimeInterval(-60*60*24))
                self.gameDict[dayString] = game
                self.upcomingGames.append(game)
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

    // selected cell
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

        currentlySelectedGame = nil

        guard let cell = cell as? CalendarCell else { fatalError() }
        cell.setSelected(true)

        DispatchQueue.main.async {
            let key = DateFormatter.withSimplifiedDayStyle.string(from: date)

            if let showOverview = self.episodeDict[key]?.1 {
                if let posterPath = showOverview.posterPath, let posterURL = URL(string: APIDAO.imdbImageRoot+posterPath) {
                    self.imageCard.imageView.kf.setImage(with: posterURL)
                    return
                }
            }

            if let game = self.gameDict[key] {
                self.currentlySelectedGame = game
                GameService.fetchCoverImageUrl(cover: game.cover) { coverImageUrl in
                    DispatchQueue.main.async {
                        self.imageCard.imageView.kf.setImage(with: coverImageUrl)
                    }
                }
            }

            self.imageCard.imageView.image = nil
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

        let key = DateFormatter.withSimplifiedDayStyle.string(from: date)

        if let (episode, overview) = episodeDict[key] {
            cell.configure(for: cellState, episode: episode, overview: overview)
        }

        if let game = gameDict[key] {
            cell.configure(for: cellState, game: game)
        }
    }

    // Use dataSource to make cells
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {

        // FIXME: Find a way to display multiple episodes and games on one date

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.resetStyle(cellState)

        let key = DateFormatter.withSimplifiedDayStyle.string(from: date)
        if let (episode, overview) = episodeDict[key] {
            cell.configure(for: cellState, episode: episode, overview: overview)
        }

        if let game = gameDict[key] {
            cell.configure(for: cellState, game: game)
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

    @objc func presentGameScreen() {
        if let game = currentlySelectedGame {
            let gameScreen = GameScreen(game, platform: .tbd)
            present(gameScreen, animated: true)
        }
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: style.calendarHeaderHeight)
    }
}



extension DateFormatter {
    static var withSimplifiedDayStyle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        return dateFormatter
    }()
}
