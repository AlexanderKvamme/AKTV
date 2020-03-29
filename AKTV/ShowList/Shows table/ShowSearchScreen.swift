//
//  ShowSearchScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

// This is where the app starts

final class ShowSearchScreen: UIViewController {
    
    // MARK: Properties
    
    private let searchField = UITextField()
    private let episodesSearchResultViewController = UIViewController()
    private let episodesSearchResultDataDelegate = EpisodesSearchResultDataDelegate()
    private let apiDao: APIDAO
    
    // MARK: Initializers
    
    init(dao: APIDAO) {
        apiDao = dao
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .green
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
}

// MARK: - Make self textview delegate

extension ShowSearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        
        let shows = apiDao.searchShows(string: searchterm)
        print("bam successfully returned these shows: ", shows)
        
        return true
    }
}
