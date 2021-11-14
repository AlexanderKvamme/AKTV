//
//  FavouriteListView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 07/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI

struct FavouriteListView: View {

    var selected: MediaPickable?
    @State var isActive = false
    @ObservedObject var viewModel = ViewModel()
    var start = Date().timeIntervalSince1970

    class ViewModel: ObservableObject {
        @Published var shows = [Show]()
        @Published var selectedShow: Show?
    }
    
    var body: some View {

        if viewModel.selectedShow != nil {
            NavigationLink("", isActive: $isActive) {
                SUDetailedShow(show: viewModel.selectedShow!)
            }
            .frame(width: 0, height: 0)
            .hidden()
        }

        ZStack {
            // Denne funker alene
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(light)
            List(viewModel.shows) { item in
                FavouriteListRow(show: item)
                    .onTapGesture {
                        viewModel.selectedShow = item
                        isActive = true
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .ignoresSafeArea()
            .onAppear(perform: {
                viewModel.selectedShow = nil
                testGettingFavourites()
            })
        }
    }
    
    func testGettingFavourites() {
        let favs = UserProfileManager().favouriteShows()
        favs.forEach { showId in
            APIDAO().show(withId: showId) { show in
                print("bam after \(Date().timeIntervalSince1970 - start) ms appending \(show.name)")
                DispatchQueue.main.async {
                    if !self.viewModel.shows.contains(where: { existing in
                        existing.id == show.id
                    }) {
                        self.viewModel.shows.append(show)
                    }
                }
            }
        }
    }
}


struct FavouriteListRow: View {
    
    @State var show: Show
    
    var body: some View {
        HStack {
            Image("showDummy")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .cornerRadius(14)
                .clipped()
            Text(show.name)
                .font(Font.gilroy(.bold, 20))
                .foregroundColor(dark)

        }
        .listRowBackground(Color.clear)
    }
}

func measureTime() {
    let start = Date().timeIntervalSinceNow
    APIDAO().showOverview(withId: 1233) { show in
        let diff = Date().timeIntervalSinceNow - start
        print("Took \(diff) to get: ", show.name)
    }
}
