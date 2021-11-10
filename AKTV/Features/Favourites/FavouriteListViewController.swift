//
//  FavouriteListViewController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 31/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


let lightColor = Color(UIColor(light))

struct FavouriteRow: View {

    var show: ShowOverview

    var body: some View {
        print("making cell for: ", show.name)
        return HStack {
            Image("default-placeholder-image")
                .resizable()
                .frame(width: 50, height: 50)
            Text(show.name)

            Spacer()
        }
    }
}

struct EntityList: View {

    @State var shows = [ShowOverview]()

    var body: some View {

        print("bam body")

        return NavigationView {
            List(shows) { dummy in
                let destination = ShowOverViewSUWrapper()
                NavigationLink(destination: destination) {
                    FavouriteRow(show: dummy)
                }
            }
            .navigationBarHidden(true)
            .background(Color.blue)
        }
        .background(Color.orange)
    }
}


final class FavouriteListViewController: UIViewController {

    // MARK: - Properties

    var entityList = EntityList()
    var shows = [ShowOverview]()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: entityList)
        addChild(childView)
        childView.view.frame = screenFrame
        childView.didMove(toParent: self)
        view.addSubview(childView.view)
    }

    // MARK: - Methods

    func addShow(_ showOverView: ShowOverview) {
        shows.append(showOverView)
        print("appending: ", showOverView.name)
        print(shows.count)
        entityList.shows = shows
    }
}

