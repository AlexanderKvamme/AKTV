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

    let stackHeight = 40
    let labelWidth: Int = 120

    let overviewLabel = UILabel.make(.subtitle, "Overview")
    let headerLabel = UILabel.make(.header, "Upcoming")
    let headerStack = UIStackView()
    let stack = UIStackView()

    // MARK: Initializers

    init() {
        // TODO: Fix a proper calculated height
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 148))
        
        setup()

        let dayNames = ["Wednesday", "Thursday", "Saturday", "Monday", "Tuesday", "Wednesday"]
        let horizontalView = makeChainedHorizontalView(dayNames)
        let horizontalScrollView  = makeHorizontalScrollView(containing: horizontalView)

        headerStack.addArrangedSubview(overviewLabel)
        headerStack.addArrangedSubview(headerLabel)
        stack.addArrangedSubview(horizontalScrollView)

        horizontalView.snp.makeConstraints { (make) in
            make.height.equalTo(stackHeight)
        }

        addSubview(headerStack)
        headerStack.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
        }

        addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(headerStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

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
            //            lbl.backgroundColor = .orange
            lbl.textAlignment = .center
            lables.append(lbl)
        }

        // Add a label chain
        if lables.count != 0 {
            let firstLabel = lables.first!
            horizontalView.addSubview(firstLabel)
            firstLabel.snp.makeConstraints { (make) in
                make.left.bottom.top.equalToSuperview()
                make.width.equalTo(labelWidth)
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

    private func setup() {
        overviewLabel.font = UIFont.gilroy(.medium, 24)
        overviewLabel.alpha = Alpha.medium
        overviewLabel.textColor = UIColor(dark)
        headerLabel.text = "Upcoming shows".uppercased()
        headerLabel.textColor = UIColor(dark)

        headerStack.axis = .vertical

        stack.axis = .vertical
        stack.spacing = 4

        backgroundColor = UIColor(light)
        backgroundColor = .green
    }

    func makeDayLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.gilroy(.heavy, 14)
        label.textColor = UIColor(dark)
        label.alpha = Alpha.faded
        return label
    }
}
