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
    var episodeDict = [Date : (Episode, ShowOverview)]()
    var formatter = DateFormatter.withoutTime
    var upcomingFavourites = [Episode]() {
        didSet {
            let datesAdded = upcomingFavourites.compactMap{ $0.getFormattedDate() }
            cv.reloadDates(datesAdded)
        }
    }
    weak var tabBar: CustomTabBarDelegate?

    // MARK: - Initializers

    init(tabBar: CustomTabBarDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.tabBar = tabBar

        view.backgroundColor = UIColor(light)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBar?.hideIt()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPremiereDates()
    }

    // MARK: - Methods

    private func fetchPremiereDates() {
        let dao = APIDAO()
        let favShows = UserProfileManager().favouriteShows()

        favShows.forEach {
            dao.show(withId: $0) { overview in
                dao.episodes(showId: overview.id, seasonNumber: overview.numberOfSeasons) { season in
                    DispatchQueue.main.async {
                    season.episodes.forEach { episode in
                        if let formattedDate = episode.getFormattedDate() {
                            // FIXME: Should allow for multiple episodes on one day
                            self.episodeDict[formattedDate] = (episode, overview)
                            self.upcomingFavourites.append(episode)
                        }
                    }}
                }
            }
        }
    }

    private func setup() {
        let exitTapGesture = UITapGestureRecognizer(target: self, action: #selector(exitScreen))
        chevronButton.addGestureRecognizer(exitTapGesture)
        chevronButton.isUserInteractionEnabled = true

        tabBar?.hideIt()

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
        chevronButton.tintColor = UIColor(dark).withAlphaComponent(0.0)

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

        guard let cell = cell as? CalendarCell else { fatalError() }
        cell.setSelected(true)

        DispatchQueue.main.async {
            if let showOverview = self.episodeDict[date]?.1 {
                if let posterPath = showOverview.posterPath, let posterURL = URL(string: APIDAO.imageRoot+posterPath) {
                    self.imageCard.imageView.kf.setImage(with: posterURL)
                    return
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

        if let (episode, overview) = episodeDict[date] {
            cell.configure(for: cellState, episode: episode, overview: overview)
        }
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

        cell.resetStyle(cellState)

        if let (episode, overview) = episodeDict[date] {
            cell.configure(for: cellState, episode: episode, overview: overview)
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

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: style.calendarHeaderHeight)
    }
}
