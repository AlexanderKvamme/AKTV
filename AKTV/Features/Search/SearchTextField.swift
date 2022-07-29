//
//  SearchTextField.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class SearchShowTextField: UIView {

    // MARK: - Properties

    let searchField = UITextField()
    let shadowView = ShadowView2(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        searchField.backgroundColor = .clear
        searchField.textAlignment = .center
        searchField.placeholder = "Game of thrones"
        searchField.font = UIFont.gilroy(.bold, 24)
        searchField.textColor = UIColor(light)
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        searchField.adjustsFontSizeToFitWidth = true
        searchField.layer.cornerCurve = .continuous
        searchField.layer.cornerRadius = 16
        searchField.backgroundColor = UIColor(dark)
        searchField.keyboardAppearance = .light
    }

    private func addSubviewsAndConstraints() {
        addSubview(shadowView)
        addSubview(searchField)

        searchField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().offset(16)
        }

        shadowView.snp.makeConstraints { make in
            make.top.equalTo(searchField).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(searchField).offset(-8)
        }
    }
}
