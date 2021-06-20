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
    static let calendarOffset: CGFloat = 32
    static let cornerRadius: CGFloat = 5
}

final class CalendarScreen: UIViewController {

    // MARK: - Properties

    let cv = JTACMonthView(frame: CGRect(x: 0+style.calendarOffset/2, y: screenHeight-screenWidth-100, width: screenWidth-style.calendarOffset, height: screenWidth-style.calendarOffset))
    var dayStack: UIStackView!
    var imageView = UIImageView()
    var episodeDict = [Date : Episode]()
    var upcomingFavourites = [Episode]() {
        didSet {
            let datesAdded = upcomingFavourites.compactMap{ $0.getFormattedDate() }
            cv.reloadDates(datesAdded)
        }
    }


    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

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
        print("bam favShows: ", favShows)

        // Fetch shows and then put to dataSource
        favShows.forEach{
            dao.show(withId: $0) { overview in
                if let nextAirDate = overview.nextEpisodeToAir {
                    DispatchQueue.main.async {
                        if let formattedDate = nextAirDate.getFormattedDate() {
                            self.episodeDict[formattedDate] = nextAirDate
                            print("dictionray now: ", self.episodeDict)
                        }
                        self.upcomingFavourites.append(nextAirDate)
                    }
                }
            }
        }
    }

    private func setup() {
        dayStack = makeDayStack()
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 8

        cv.backgroundColor = .clear
        cv.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        cv.calendarDelegate = self
        cv.calendarDataSource = self
        cv.minimumInteritemSpacing = 0

        cv.scrollDirection = .horizontal
        cv.scrollingMode   = .stopAtEachCalendarFrame
        cv.showsHorizontalScrollIndicator = false
        cv.clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(cv)
        view.addSubview(dayStack)
        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(dayStack.snp.top).offset(-24)
        }

        dayStack.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(style.calendarOffset)
            make.bottom.equalTo(cv.snp.top).offset(-8)
        }
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
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Date() // formatter.date(from: "2018 01 01")!
        let endDate = Date().addingTimeInterval(60*60*24*30)
        let config = ConfigurationParameters(startDate: startDate, endDate: endDate, generateInDates: InDateCellGeneration.off, generateOutDates: OutDateCellGeneration.tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        return config
    }
}


extension CalendarScreen: JTACMonthViewDelegate {

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        let episodeToHighlight = cell.getEpisode()

        // FIXME: Vis denne frem i headeren
        if let episode = episodeDict[date] {
            print("would display this episode: ", episode)
        }
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("bam will display: ", indexPath)
        cell.backgroundColor = .orange

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.configure(for: cellState, upcomingEpisodes: upcomingFavourites)
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.configure(for: cellState, upcomingEpisodes: upcomingFavourites)
        return cell
    }
}
