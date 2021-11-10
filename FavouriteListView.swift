//
//  FavouriteListView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 07/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI

struct FavouriteListView: View {

    var imageName: String = "default-placeholder-image"
    var selected: MediaPickable?

    var body: some View {
        Text("You have selected \(selected?.rawValue ?? "none")")
            .background(Color.green)
    }
}


struct FavouriteListRow: View {

    var imageName: String = "default-placeholder-image"

    var body: some View {
        Text(imageName)
    }
}
