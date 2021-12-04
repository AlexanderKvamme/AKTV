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
    private var backButton = RoundIconButton(type: .x)
    private var starButton = RoundIconButton(type: .heart)
    private var titleCard: DetailedEntityTitleCard
    private var iconRow: EntityIconRow
    private var scrollContainer = UIScrollView()
    private var scrollContent = UIView()
    private var desciptionView: DetailedEntityDescriptionView!
    private var dismissbutton = ButtonCTA()
    
    // MARK: - Initializers
    
    init(entity: Entity) {
        self.iconRow = EntityIconRow(entity)
        self.titleCard = DetailedEntityTitleCard(entity)
        self.desciptionView = DetailedEntityDescriptionView(entity)
        let backdropPath = entity.getMainGraphicsURL() ?? URL(string: "")
        imageView.kf.setImage(with: backdropPath)
        
        super.init(nibName: nil, bundle: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        hidesBottomBarWhenPushed = true
        
        setup()
        addSubviewsAndConstraints()
        iconRow.update(with: entity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Methods
    
    @objc func popScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setup() {
        backButton.addTarget(self, action: #selector(popScreen), for: .touchUpInside)
        dismissbutton.addTarget(self, action: #selector(popScreen), for: .touchUpInside)
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = .iOSCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        titleCard.makeLongInteractable()
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
        // ScrollContent is a plain UIView designed to be
        // the scrollView's only contentView
        scrollContainer.addSubview(scrollContent)
        scrollContent.addSubview(desciptionView)
        scrollContent.addSubview(dismissbutton)
        scrollContent.addSubview(iconRow)
        scrollContent.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.top.equalToSuperview()
            make.bottom.equalTo(dismissbutton.snp.bottom)
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
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(32)
            make.size.equalTo(RoundIconButton.size)
        }
        
        scrollContent.addSubview(starButton)
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-32)
            make.size.equalTo(RoundIconButton.size)
        }

        scrollContent.addSubview(titleCard)
        titleCard.snp.makeConstraints { make in
            make.centerY.equalTo(imageView.snp.bottom).offset(-16)
            make.left.right.equalTo(imageView).inset(12)
        }
        
        iconRow.snp.makeConstraints { make in
            make.top.equalTo(titleCard.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        
        desciptionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalTo(iconRow.snp.bottom).offset(24)
        }
        
        dismissbutton.snp.makeConstraints { make in
            make.top.equalTo(desciptionView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(ButtonCTA.size)
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
    
    // MARK: - Subclass
    
    enum IconType {
        case x, heart
    }
    
    // MARK: - Properties
    
    static var size: CGFloat = 34
    
    // MARK: - Initializers
    
    init(type: IconType) {
        super.init(frame: CGRect(x: 0, y: 0, width: Self.size, height: Self.size))
        
        applyButtonStyle(type)
        backgroundColor = UIColor(light)
        layer.cornerRadius = Self.size/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func applyButtonStyle(_ type: IconType) {
        switch type {
        case .x:
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .black, scale: .large)
            let symbolImage = UIImage(systemName: "plus", withConfiguration: imageConfig)!
            tintColor = UIColor(dark)
            transform = CGAffineTransform(rotationAngle: .pi/4)
            setImage(symbolImage, for: .normal)
        case .heart:
            let inset: CGFloat = 8
            imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
            setImage(UIImage(named: "icons8-heart-50-filled"), for: .normal)
        }

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


extension UIView {
    
    private func addGesture() {
        let lpr = UILongPressGestureRecognizer(target: self, action: #selector(tackleLongPress))
        lpr.cancelsTouchesInView = false
        lpr.minimumPressDuration = 0
        addGestureRecognizer(lpr)
    }
    
    @objc func tackleLongPress(_ sender: UIGestureRecognizer) {
        var tapTicker = 0.0
        switch sender.state {
        case .began:
            tapTicker -= 0.05
        case .ended, .cancelled, .failed:
            tapTicker = 0
        default:
            break
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1 + tapTicker, y: 1 + tapTicker)
        })
    }

    func makeLongInteractable() {
        addGesture()
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
        
        descriptionTextView.text = entity.description
        descriptionTextView.textColor = UIColor(dark)
        descriptionTextView.font = UIFont.gilroy(.regular, 16)
        descriptionTextView.alpha = 0.5
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


final class ButtonCTA: UIButton {
    
    // MARK: - Properties
    
    static var size = CGSize(width: 140, height: 48)

    private var label = UILabel()
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: Self.size))
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    // MARK: - Methods
    
    private func setup() {
        backgroundColor = UIColor(dark)
        layer.cornerRadius = Self.size.height/2
        label.text = "DISMISS"
        label.font = UIFont.gilroy(.bold, 16)
        label.textColor = UIColor(light)
        label.textAlignment = .center
        
        addGesture()
        generator.prepare()
    }
    
    private func addGesture() {
        let lpr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpr.minimumPressDuration = 0
        addGestureRecognizer(lpr)
    }
    
    private var tapTicker = 0.0
    
    @objc func handleLongPress(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .began:
            tapTicker -= 0.05
            generator.impactOccurred()
        case .ended, .cancelled, .failed:
            tapTicker = 0
            sendActions(for: .touchUpInside)
        default:
            break
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1 + self.tapTicker, y: 1 + self.tapTicker)
        })
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}



import SwiftUI
struct DetailedEntityScreenWrapper: UIViewControllerRepresentable {
    
    var entity: Entity
    
    init(_ entity: Entity) {
        self.entity = entity
    }
    
    func makeUIViewController(context: Context) -> DetailedEntityScreen {
        let picker = DetailedEntityScreen(entity: entity)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DetailedEntityScreen, context: Context) {
        //
    }
}
