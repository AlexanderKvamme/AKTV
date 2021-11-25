//
//  FavouriteListView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 07/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import Kingfisher
import IGDB_SWIFT_API


struct FavouriteListView<T: Entity>: View where T: Equatable & Hashable & Identifiable {

    var selected: MediaPickable?
    @State var isActive = false
    @ObservedObject var viewModel = ViewModel()

    class ViewModel: ObservableObject {
        @Published var entities = [T]()
        @Published var selectedShow: T?
    }

    var body: some View {

//        if viewModel.selectedShow != nil {
//            NavigationLink("", isActive: $isActive) {
//                SUDetailedShow(show: viewModel.selectedShow!)
//            }
//            .frame(width: 0, height: 0)
//            .hidden()
//        }

        ZStack {
//            Rectangle()
//                .ignoresSafeArea()
//                .foregroundColor(light)
            List(viewModel.entities) { entity in
                FavouriteListRow(entity: entity)
                    .onTapGesture {
                        print("tapped ", entity.name)
                        viewModel.selectedShow = entity
                        isActive = true
                    }
                    .listRowSeparator(.hidden)
                    .frame(width: 300, height: 200, alignment: .center)
            }
        }
        .onAppear(perform: {
            viewModel.selectedShow = nil
            getFavourites()
        })
        .background(Color.blue)
    }

        
//        return ZStack {
//            Rectangle()
//                .ignoresSafeArea()
//                .foregroundColor(light)
//
//        }
//        .ignoresSafeArea()
//        .onAppear(perform: {
//            viewModel.selectedShow = nil
//            getFavourites()
//        })
                            // Add spacing in bottom
//                if item == viewModel.shows.last {
//                    Rectangle()
//                    .frame(height: 100)
//                    .foregroundColor(light)
//                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//                }


//            List(viewModel.$entities, id: \.id) { item in
//                FavouriteListRow(entity: item)
//                    .onTapGesture {
//                        viewModel.selectedShow = item
//                        isActive = true
//                    }
//                    .listRowSeparator(.hidden)
//
//            }
//            .listStyle(PlainListStyle())
//            .ignoresSafeArea()
//            .onAppear(perform: {
//                viewModel.selectedShow = nil
//                getFavourites()
//            })
//        }
//    }

    func getFavourites() {
        
        // TODO: Make this an extension on Show/Proto_game/Movie?
        if T.self == Show.self {
            let favs = UserProfileManager().favouriteShows()
            favs.forEach { showId in
                APIDAO().show(withId: showId) { show in
                    DispatchQueue.main.async {
                        let entity = show as! T
                        self.viewModel.entities.append(entity)
                    }
                        
//                        if !self.viewModel.entities.contains(where: { existing in
//                            // existing.id // hashable
//                            print("iffing")
//                            let entity = show as Entity
//                            return entity.id == show.id
//                        }) {
//                            print("\(show.name) was not contained")
//                            let entity = show as! T
//                            self.viewModel.entities.append(entity)
//                        }
//                    }
                }
            }
        } else if T.self == Movie.self {
            let favs = UserProfileManager().favouriteMovies()
            favs.forEach { movieId in
                APIDAO().movie(withId: UInt64(movieId)) { movie in
                    DispatchQueue.main.async {
                        let entity = movie as! T
                        self.viewModel.entities.append(entity)
                    }
                }
            }
        } else if T.self == Proto_Game.self {
            let favs = GameStore.getFavourites()
            favs.forEach { gameId in
                APIDAO().game(withId: UInt64(gameId)) { game in
                    DispatchQueue.main.async {
                        let entity = game as! T
                        self.viewModel.entities.append(entity)
                    }
                }
            }
        }
    }
}


struct FavouriteListRow<T: Entity>: View {

    @State var entity: T

    var body: some View {
        return HStack {
            KFImage.url(entity.getMainGraphicsURL())
                .loadImmediately()
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .cornerRadius(14)
                .clipped()
            Text(entity.name)
                .font(Font.gilroy(.bold, 20))
                .foregroundColor(dark)
        }
        .listRowBackground(Color.clear)
    }
}
