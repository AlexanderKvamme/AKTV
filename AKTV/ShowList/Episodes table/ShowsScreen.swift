//
//  ShowListScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class ShowsScreen: UIViewController {
    
    // MARK: Properties
    
    private let searchField = UITextField()
    private let episodesSearchResultViewController = UIViewController()
    private let episodesSearchResultDataDelegate = ShowsDataDelegate()
    private let apiDao: APIDAO
    
    // MARK: Initializers
    
    init(dao: APIDAO) {
        apiDao = dao
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .purple
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        apiDao.trytestMappingBBT()
    }
    
    // MARK: Private methods
    
    private func setup() {
        searchField.backgroundColor = .green
        searchField.placeholder = "Søk her"
        searchField.delegate = self
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(searchField)
        
        searchField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
}

// MARK: - Make self textview delegate

extension ShowsScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("bam returned on: ", textField.text ?? "empty")
        
        if let searchterm = textField.text {
            let tvSeries = apiDao.searchShows(string: searchterm)
            // TODO: Actually return a show or somethin
        }
        
        return true
    }
}

// MARK: - Make self episodesdelegate

struct Series {
    let name: String
}

protocol SeriesReceiver {
    func receive(series: [Series])
}

extension ShowsScreen: SeriesReceiver {
    func receive(series: [Series]) {
        print("bam returned series: ", series)
    }
}


