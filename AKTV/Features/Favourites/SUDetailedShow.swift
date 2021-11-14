//
//  DetailedShow.swift
//  AKTV
//
//  Created by Alexander Kvamme on 14/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct SUDetailedShow: View {

    @State var show: Show

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(light)
                .ignoresSafeArea()
        VStack(spacing: 24) {
            KFImage(show.getBackdropUrl())
                .fade(duration: 0.25)
                .frame(width: screenWidth-32, height: 300, alignment: .top)
                .scaledToFit()
                .cornerRadius(14)
                .clipped()
                .shadow(radius: 5)

            Text(show.name)
                .font(Font.gilroy(GilroyWeights.bold, 32))
                .foregroundColor(dark)

            Text("Add some more stuff here")
                .font(Font.gilroy(.regular, 16))
                .foregroundColor(dark)

            Spacer()
        }
    }
}

struct EntityImage: View {

    @State var show: Show

    var body: some View {
        let backdropPath = show.backdropPath!
        let url = URL(string: APIDAO.imdbImageRoot+backdropPath)!

        VStack {
            AsyncImage(url: url)
        }
    }
}
}

