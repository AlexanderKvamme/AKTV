//
//  UpcomingTableHeader.swift
//  AKTV
//
//  Created by Alexander Kvamme on 28/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit


final class UpcomingTableHeader: UIView {

    // MARK: Properties

    let stackHeight = 30
    let labelWidth: Int = 110

    let overviewLabel = UILabel.make(.subtitle, "Overview")
    let headerLabel = UILabel.make(.header, "Upcoming")
    let dayStack = UIStackView()

    let dayNames = ["Wednesday", "Thursday", "Saturday", "Monday", "Tuesday", "Wednesday"]

    // MARK: Initializers

    init() {
        // TODO: Fix a proper calculated height
        super.init(frame: .zero)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
//                overviewLabel.backgroundColor = .yellow
//                headerLabel.backgroundColor = .cyan
//                dayStack.backgroundColor = .purple

        overviewLabel.font = UIFont.gilroy(.semibold, 24)
        overviewLabel.alpha = Alpha.faded
        overviewLabel.textColor = UIColor(dark)
        headerLabel.text = "Upcoming shows".uppercased()
        headerLabel.textColor = UIColor(dark)

        dayStack.axis = .horizontal
        dayStack.spacing = 4

        backgroundColor = UIColor(light)
    }

    private func addSubviewsAndConstraints() {
        let dayChain = makeChainedHorizontalView(dayNames)
        let dayScrollView  = makeHorizontalScrollView(containing: dayChain)

        dayStack.addArrangedSubview(dayScrollView)

        addSubview(headerLabel)
        addSubview(overviewLabel)
        addSubview(dayStack)

        overviewLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(48)
        }

        headerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(overviewLabel.snp.bottom)
            make.left.equalTo(overviewLabel)
        }

        dayChain.snp.makeConstraints { (make) in
            make.height.equalTo(stackHeight)
        }

        dayStack.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func makeHorizontalScrollView(containing subview: UIView) -> UIScrollView {
        let horizontalScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: stackHeight))
        horizontalScroll.showsHorizontalScrollIndicator = false
        horizontalScroll.contentSize = CGSize(width: labelWidth*6, height: stackHeight)
        horizontalScroll.addSubview(subview)
        return horizontalScroll
    }

    private func makeChainedHorizontalView(_ dayNames: [String]) -> UIView {
        let horizontalView = UIView()
        var lables = [UILabel]()

        dayNames.forEach { (str) in
            let lbl = makeDayLabel()
            lbl.frame = CGRect(x: 0, y: 0, width: 100, height: stackHeight)
            lbl.text = str.uppercased()
            lbl.textAlignment = .center
            lables.append(lbl)
        }

        // Add a label chain
        if lables.count != 0 {
            let firstLabel = lables.first!
            firstLabel.alpha = Alpha.max
            firstLabel.font = UIFont.gilroy(.heavy, 20)
            firstLabel.frame.size.width = 300

            horizontalView.addSubview(firstLabel)
            firstLabel.snp.makeConstraints { (make) in
                make.left.bottom.top.equalToSuperview()
                make.width.equalTo(200)
            }

            var previous = firstLabel
            lables.dropFirst().dropLast().forEach { (label) in
                horizontalView.addSubview(label)
                label.snp.makeConstraints { (make) in
                    make.left.equalTo(previous.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(labelWidth)
                }
                previous = label
            }

            let lastLabel = lables.last!
            horizontalView.addSubview(lastLabel)
            lastLabel.snp.makeConstraints { (make) in
                make.left.equalTo(previous.snp.right)
                make.top.bottom.equalToSuperview()
                make.right.equalToSuperview()
                make.width.equalTo(labelWidth)
            }
        }

        return horizontalView
    }

    private func makeDayLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.gilroy(.heavy, 14)
        label.textColor = UIColor(dark)
        label.alpha = Alpha.faded
        return label
    }
}
