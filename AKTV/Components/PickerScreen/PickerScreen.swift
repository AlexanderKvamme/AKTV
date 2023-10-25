//
//  PickerScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

protocol Pickable { }

enum MediaPickable: String, CaseIterable, Identifiable, Pickable {
    var id: RawValue { rawValue }

    case tvShow = "TV show"
    case movie = "Movie"
    case game = "Game"
}

typealias PickerCompletionHandler = ((Pickable) -> ())


class PickerScreen: UIViewController {

    // MARK: - Properties

    let header = UILabel()
    let subHeader = UILabel.make(.subtitle, color: UIColor(dark))
    private var pickables: [Pickable]
    private var stackView = UIStackView()
    private var buttons: [UIButton]

    var completion: PickerCompletionHandler?

    // MARK: - Initializers

    init(header: String, subheader: String, _ pickables: [Pickable], onCompletion: PickerCompletionHandler?) {
        self.header.text = header
        self.subHeader.text = subheader
        self.completion = onCompletion
        self.pickables = pickables
        self.buttons = pickables.map({ (pickable) -> UIButton in
            let mediaPickable = pickable as! MediaPickable
            let btn = UIButton.make(.pickable)
            btn.titleLabel?.text = mediaPickable.rawValue
            btn.setTitle(mediaPickable.rawValue, for: .normal)
            btn.titleLabel?.font = UIFont.gilroy(.bold, 16)
            return btn
        })

        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setup() {
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = UIColor(light)

        stackView.contentMode = .bottom
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.clipsToBounds = true
        header.font = UIFont.gilroy(.heavy, 38)
        header.textAlignment = .left
        header.textColor = UIColor(dark)
        header.numberOfLines = 0
        subHeader.textAlignment = .left
        subHeader.textColor = UIColor(dark)
        subHeader.numberOfLines = 0
    }

    func addSubviewsAndConstraints() {
        let hInset: CGFloat = 40
        let vinset: CGFloat = 16

        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(subHeader)
        subHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(vinset).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(stackView)

        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().offset(-TabBarSettings.height - 24)
        }

        // TODO: Make buttons decide size themselves
        buttons.forEach({
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(64)
                make.width.equalTo(400)
            }

            $0.addTarget(self, action: #selector(selectButton), for: .touchUpInside)

            stackView.addArrangedSubview($0)
        })
    }

    @objc func selectButton(_ sender: UIButton) {
        if let idx = buttons.firstIndex(where: {$0 == sender} ) {
            let pickedItem = pickables[idx]
            completion?(pickedItem)
        }
    }
}


extension UIButton {

    enum MyButtonType {
        case pickable
    }

    static func make(_ type: MyButtonType) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200)).style(type)
        return button
    }

    private func style(_ type: MyButtonType) -> UIButton {
        switch type {
        case .pickable:
            backgroundColor = .black
            titleLabel?.textColor = UIColor(light)

            layer.shadowColor = UIColor(.black).cgColor
            layer.shadowOpacity = 0.1
            layer.cornerCurve = .continuous
            layer.cornerRadius = 14
            layer.shadowRadius = 20
            layer.shadowOffset = CGSize(width: 0, height: 16)
        }

        return self
    }
}
