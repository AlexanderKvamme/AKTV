//
//  SearchHeaderContainer.swift
//  AKTV
//
//  Created by Alexander Kvamme on 09/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

final class SearchHeaderContainer: UIViewController {

    private let header = UILabel()
    let subHeader = UILabel()
    let searchField = SearchShowTextField(frame: .zero)

    override func viewDidLoad() {
        setup()
        addSubviewsAndConstraints()
    }

    func setup() {
        header.font = UIFont.gilroy(.heavy, 38)
        header.textAlignment = .left
        header.text = "What are you looking for?"
        header.textColor = UIColor(dark)
        header.numberOfLines = 0

        subHeader.font = UIFont.gilroy(.regular, 20)
        subHeader.textAlignment = .left
        subHeader.alpha = 0.4
        subHeader.text = "Search for any TV show in the world!"
        subHeader.textColor = UIColor(dark)
        subHeader.numberOfLines = 0
    }

    func addSubviewsAndConstraints() {
        let hInset: CGFloat = 40
        let vinset: CGFloat = 16

        view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(80).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(subHeader)
        subHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(vinset).priority(.high)
            make.left.right.equalToSuperview().inset(hInset)
        }

        view.addSubview(searchField)
        searchField.snp.makeConstraints { (make) in
            make.top.equalTo(subHeader.snp.bottom).offset(vinset).priority(.low)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}