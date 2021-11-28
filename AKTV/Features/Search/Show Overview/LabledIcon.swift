//
//  LabledIcon.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class UnlabeledIconButton: UIButton {

    // MARK: - Properties

    fileprivate var icon = UIImageView(frame: CGRect.defaultButtonRect)

    // MARK: - Initializers

    init(icon: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        setup(iconName: icon)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup(iconName: String) {
        let iconConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        icon.image = UIImage(systemName: iconName, withConfiguration: iconConfiguration)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(dark)
    }

    fileprivate func addSubviewsAndConstraints() {
        [icon].forEach({ addSubview($0) })

        icon.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(28)
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        fatalError("Use custom initializer instead.")
    }

    func setIconAlpha(_ val: CGFloat) {
        icon.alpha = val
    }
}


class LabeledIconButton: UIButton {

    // MARK: - Properties

    fileprivate var icon = UIImageView(frame: CGRect.defaultButtonRect)
    fileprivate var label = UILabel()

    // MARK: - Initializers

    init(text: String, icon: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        setup(iconName: icon, text: text)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup(iconName: String, text: String) {
        let iconConfiguration = UIImage.SymbolConfiguration(scale: .small)
        icon.image = UIImage(systemName: iconName, withConfiguration: iconConfiguration)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(dark)
        label.text = text.uppercased()
        label.textColor = UIColor(dark)
        label.textAlignment = .center
        label.font = UIFont.gilroy(.semibold, 12)
        label.alpha = Alpha.faded
        label.sizeToFit()
    }

    fileprivate func addSubviewsAndConstraints() {
        [icon, label].forEach({ addSubview($0) })

        icon.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(28)
        }

        label.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(4)
            make.left.bottom.right.equalToSuperview()
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        fatalError("Use custom initializer instead.")
    }

    func setIconAlpha(_ val: CGFloat) {
        icon.alpha = val
    }
}

protocol TMDBPresentable {
    func getId() -> Int
    func getVoteAverage() -> Double
}


final class UnlabeledRatingIcon: UnlabeledIconButton {
    
    // MARK: - Properties
    
    private var endValue: Double
    private var ratingLabel = UpCountingLabel()
    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
    
    // MARK: - Initializers
    
    init(targetNumber: Double) {
        self.endValue = targetNumber
        super.init(icon: "USE NUMBER LABEL INSTEAD")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func addSubviewsAndConstraints() {
        super.addSubviewsAndConstraints()
        
        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func update(with entity: Entity) {
        endValue = entity.rating
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func handleUpdate() {
        guard let labelText = ratingLabel.text, let currentValue = Double(labelText) else {
            return
        }
        
        let animationDurationInSeconds = 1.0
        let step = endValue/animationDurationInSeconds/60
        let newValue = currentValue+step
        ratingLabel.text = String(format:"%.1f", newValue)
        
        if currentValue >= endValue {
            ratingLabel.text = String(endValue)
            displayLink.remove(from: .main, forMode: .default)
        }
    }
}



final class RatingIcon: LabeledIconButton {

    // MARK: - Properties

    private var endValue: Double
    private var ratingLabel = UpCountingLabel()
    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
    
    // MARK: - Initializers
    
    init(text: String, targetNumber: Double) {
        self.endValue = targetNumber
        super.init(text: text, icon: "USE NUMBER LABEL INSTEAD")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func addSubviewsAndConstraints() {
        super.addSubviewsAndConstraints()

        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(label.snp.top)
        }
    }

    func update(with motionType: TMDBPresentable) {
        endValue = motionType.getVoteAverage()
        displayLink.add(to: .main, forMode: .default)
    }

    @objc private func handleUpdate() {
        guard let labelText = ratingLabel.text, let currentValue = Double(labelText) else {
            return
        }

        let animationDurationInSeconds = 1.0
        let step = endValue/animationDurationInSeconds/60
        let newValue = currentValue+step
        ratingLabel.text = String(format:"%.1f", newValue)

        if currentValue >= endValue {
            ratingLabel.text = String(endValue)
            displayLink.remove(from: .main, forMode: .default)
        }
    }
}


final class StarLabeledIcon: UnlabeledIconButton {

    // MARK: - Properties

    private var showOverview: ShowOverview?
    private var movie: Movie?

    // MARK: - Initializers

    init() {
        super.init(icon: "heart")

        addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setFilled(_ fill: Bool) {
        let iconConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let newIcon = fill ? "heart.fill" : "heart"
        icon.image = UIImage(systemName: newIcon, withConfiguration: iconConfiguration)
    }

    private func getId() -> Int? {
        if ((movie == nil && showOverview == nil) || (movie != nil && showOverview != nil)) {
            print("Should only contain one data type")
            return nil
        }

        if let id = showOverview?.id {
            return id
        }

        if let m = movie {
            return Int(m.id)
        }

        return nil
    }

    private var motionType: MotionType {
        if movie != nil {
            return .movie
        } else if showOverview != nil {
            return .tvShow
        }

        fatalError()
    }

    private func isFavorite() -> Bool {
        guard let id = getId() else { return false }

        let favShows = UserProfileManager().favouriteShows()
        return favShows.contains(id)
    }

    @objc func didTapHeart() {
        guard let id = getId() else {
            fatalError("Error: Could not find id to favorite")
        }

        let profileManager = UserProfileManager()

        if motionType == .tvShow {
            if isFavorite() {
                setFilled(false)
                profileManager.setFavouriteShow(id: id, favourite: false)
            } else {
                setFilled(true)
                profileManager.setFavouriteShow(id: id, favourite: true)
            }
        } else if motionType == .movie {
            if isFavorite() {
                setFilled(false)
                profileManager.setFavouriteMovie(id: id, favourite: false)
            } else {
                setFilled(true)
                profileManager.setFavouriteMovie(id: id, favourite: true)
            }
        }
    }

    func update(with overview: ShowOverview) {
        self.showOverview = overview

        setFilled(isFavorite())
    }

    func update(with movie: Movie) {
        self.movie = movie

        setFilled(isFavorite())
    }
}
