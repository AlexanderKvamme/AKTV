//
//  PickerScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class MediaTypePickerScreen: PickerScreen {

    // MARK: - Initializers

    init(header: String, subheader: String, onCompletion: PickerCompletionHandler? = nil) {
        let mediaPickables: [MediaPickable] = [.tvShow, .game, .movie]

        super.init(header: header, subheader: subheader, mediaPickables, onCompletion: onCompletion)

        setup()

        if onCompletion == nil {
            completion = handleMediaTypePicked(_:)
        }
    }

    func addCustomNavBarBackButton() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

        // Custom background (transluscent)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 24, y: 10, width: 24, height: 24))

        // Custom image
        if let imgBackArrow = UIImage(named: "close-48") {
            imageView.image = imgBackArrow
        }
        view.addSubview(imageView)

        let backTap = UITapGestureRecognizer(target: self, action: #selector(pop))
        view.addGestureRecognizer(backTap)

        let leftBarButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc private func pop() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Methods

    override func setup() {
        super.setup()
        view.backgroundColor = UIColor(light)
    }

    func handleMediaTypePicked(_ picked: Pickable) -> Void {
        guard picked is MediaPickable else {
            fatalError("Must pick a media type")
        }

        let dao = APIDAO()
        switch picked {
        case MediaPickable.game:
            let searchController = SearchScreen(dao: dao, searchTypes: .game)
            searchController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(searchController, animated: true)
        case MediaPickable.tvShow:
            let showSearchController = SearchScreen(dao: dao, searchTypes: .show)
            showSearchController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(showSearchController, animated: true)
        case MediaPickable.movie:
            let showSearchController = SearchScreen(dao: dao, searchTypes: .movie)
            showSearchController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(showSearchController, animated: true)
        default:
            print("Unhandled media type selected")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

