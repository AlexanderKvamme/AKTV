//
//  DetailedShow.swift
//  AKTV
//
//  Created by Alexander Kvamme on 14/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class DetailedEntityScreen: UIViewController {
    
    // MARK: - Properties
    
    private var imageView = UIImageView()
    private var backButton = RoundIconButton(icon: "close-48")
    private var starButton = RoundIconButton(icon: "icons8-heart-50-filled")
    private var titleCard: DetailedEntityTitleCard
    private var scrollContainer = UIScrollView()
    private var scrollContent = UIView()
    private var desciptionView: DetailedEntityDescriptionView!
    
    // MARK: - Initializers
    
    init(entity: Entity) {
        self.titleCard = DetailedEntityTitleCard(entity)
        self.desciptionView = DetailedEntityDescriptionView(entity)
        let backdropPath = entity.getMainGraphicsURL() ?? URL(string: "")
        imageView.kf.setImage(with: backdropPath)
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setup() {
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = .iOSCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            var contentRect = CGRect.zero
            
            for view in self.scrollContainer.subviews {
                contentRect = contentRect.union(view.frame)
            }
            
            self.scrollContainer.contentSize = contentRect.size
        }
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(scrollContainer)
        
        scrollContainer.isScrollEnabled = true
        
        // Content
        scrollContainer.addSubview(scrollContent)
        scrollContent.addSubview(desciptionView)
        scrollContent.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.top.equalToSuperview()
            make.bottom.equalTo(desciptionView.snp.bottom)
        }
        
        scrollContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight)
        }
        
        scrollContent.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(screenHeight*0.6)
        }
        
        scrollContent.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(24)
            make.size.equalTo(RoundIconButton.size)
        }
        
        scrollContent.addSubview(starButton)
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(RoundIconButton.size)
        }

        scrollContent.addSubview(titleCard)
        titleCard.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.bottom).offset(-16)
            make.left.right.equalTo(imageView).inset(8)
        }
        
        desciptionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalTo(titleCard.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
        
        scrollContent.setNeedsLayout()
        scrollContent.layoutIfNeeded()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
}

final class RoundIconButton: UIButton {
    
    // MARK: - Properties
    
    static var size: CGFloat = 40
    
    // MARK: - Initializers
    
    init(icon: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: Self.size, height: Self.size))
        
        backgroundColor = UIColor(light)
        setImage(UIImage(named: icon), for: .normal)
        
        let inset: CGFloat = 12
        imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        layer.cornerRadius = Self.size/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


final class DetailedEntityTitleCard: UIView {
    
    // MARK: - Properties
    
    private var card = Card(radius: 24)
    private var entity: Entity
    private var nameLabel = UILabel.make(.subtitle)
    private var ratingLabel = UILabel.make(.subtitle)
    private var starIcon = UIImageView(image: UIImage(named: "star")!.withRenderingMode(.alwaysTemplate))
    private var statusLabel = UILabel.make(.subtitle)
    
    // MARK: - Initializers
    
    init(_ entity: Entity) {
        self.entity = entity
        
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setup() {
        nameLabel.text = entity.name
        nameLabel.textColor = UIColor(dark)
        nameLabel.font = UIFont.round(.bold, 24)
        
        ratingLabel.text = String(entity.rating)
        ratingLabel.textColor = UIColor(dark)
        ratingLabel.font = UIFont.gilroy(.bold, 12)
        ratingLabel.font = UIFont.gilroy(.extraBold, 13)
        ratingLabel.alpha = 1
        
        starIcon.tintColor = UIColor(hex: "EF6335")
        
        statusLabel.text = entity.releaseStatus.rawValue
        statusLabel.textColor = UIColor(dark)
        statusLabel.textAlignment = .right
        statusLabel.font = UIFont.round(.bold, 16)
        statusLabel.alpha = 0.3
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(card)

        // self
        snp.makeConstraints { make in
            make.height.equalTo(card)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(8)
        }
        
        addSubview(ratingLabel)
        ratingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(nameLabel)
        }
        
        addSubview(starIcon)
        starIcon.snp.makeConstraints { make in
            make.size.equalTo(12)
            make.centerY.equalTo(ratingLabel).offset(-2)
            make.left.equalTo(ratingLabel.snp.right).offset(8)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(starIcon.snp.left)
            make.top.bottom.equalTo(ratingLabel)
            make.right.equalToSuperview().offset(-16)
        }

        let vOffset: CGFloat = 16
        card.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).offset(-vOffset)
            make.bottom.equalTo(ratingLabel).offset(vOffset)
            make.left.right.equalToSuperview()
        }
        
    }

}


final class DetailedEntityDescriptionView: UIView {
    
    // MARK: - Properties
    
    private var entity: Entity
    private var descriptionTitleLabel = UILabel()
    private var descriptionTextView = UITextView()
    
    // MARK: - Initializers
    
    init(_ entity: Entity) {
        self.entity = entity
        
        super.init(frame: .zero)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    // MARK: - Methods
    
    private func setup() {
        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.textColor = UIColor(dark)
        descriptionTitleLabel.font = UIFont.gilroy(.extraBold, 16)
        
        descriptionTextView.text = entity.description + entity.description + entity.description
        descriptionTextView.textColor = UIColor(dark)
        descriptionTextView.font = UIFont.gilroy(.regular, 14)
        descriptionTextView.alpha = 0.8
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(descriptionTitleLabel)
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            let hOffSet: CGFloat = 4
            make.right.equalTo(descriptionTitleLabel).offset(hOffSet)
            make.left.equalTo(descriptionTitleLabel).offset(-hOffSet)
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
    }

}
