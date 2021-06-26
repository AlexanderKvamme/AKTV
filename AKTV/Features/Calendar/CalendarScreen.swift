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
    static let calendarHorizontalOffset: CGFloat    = 32
    static let calendarHeight: CGFloat              = 240
    static let calendarBottomOffset: CGFloat        = 40

    static let cornerRadius: CGFloat                = 5
}

final class CalendarScreen: UIViewController {

    // MARK: - Properties

    let xButton = IconButton.make(.x)
    let cv = JTACMonthView(frame: CGRect(x: 0+style.calendarHorizontalOffset/2, y: screenHeight-style.calendarHeight-style.calendarBottomOffset, width: screenWidth-style.calendarHorizontalOffset, height: style.calendarHeight))
    var dayStack: UIStackView!
    var imageView = UIImageView()
    var episodeDict = [Date : (Episode, ShowOverview)]()
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
        fetchPremiereDates()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        xButton.addTarget(self, action: #selector(exitScreen), for: .touchDown)
        tabBar?.hideIt()

        dayStack = makeDayStack()
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        cv.backgroundColor = .clear
        cv.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        cv.calendarDelegate = self
        cv.calendarDataSource = self
        cv.minimumInteritemSpacing = 0
        cv.scrollToDate(Date(), animateScroll: false)

        cv.scrollDirection = .horizontal
        cv.scrollingMode = .stopAtEachCalendarFrame
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(xButton)
        view.addSubview(cv)
        view.addSubview(dayStack)
        view.addSubview(imageView)

        xButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(48)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(dayStack.snp.top).offset(-24)
        }

        dayStack.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(style.calendarHorizontalOffset)
            make.bottom.equalTo(cv.snp.top).offset(-8)
        }
    }

    @objc func exitScreen() {
        tabBarController?.selectedIndex = 1
    }

    private func makeDayStack() -> UIStackView {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalCentering

        let dayLabels = days.map{ (str) -> UILabel in
            let lbl = UILabel()
            lbl.font = UIFont.round(.bold, 28)
            lbl.text = str
            lbl.textColor = UIColor(dark)
            return lbl
        }

        dayLabels.forEach{ stackView.addArrangedSubview($0) }
        return stackView
    }
}

extension CalendarScreen: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        let day: TimeInterval = 60*60*24
        let month: TimeInterval = day*31
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Date().addingTimeInterval(-3*month) // formatter.date(from: "2018 01 01")!
        let endDate = Date().addingTimeInterval(3*month)
        let config = ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        return config
    }
}


extension CalendarScreen: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        // FIXME: Vis denne frem i headeren
        if let showOverview = episodeDict[date]?.1 {
            if let posterPath = showOverview.posterPath, let posterURL = URL(string: APIDAO.imageRoot+posterPath) {
                self.imageView.kf.setImage(with: posterURL)
            }
        }
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarCell else {
            fatalError()
        }

        cell.configure(for: cellState, upcomingEpisodes: upcomingFavourites)
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.configure(for: cellState, upcomingEpisodes: upcomingFavourites)
        return cell
    }
}
