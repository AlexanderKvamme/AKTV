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

    @State var isActive = false
    @ObservedObject var viewModel = ViewModel()

    class ViewModel: ObservableObject {
        @Published var entities = [T]()
        @Published var selectedEntity: T?
    }

    var body: some View {

        if viewModel.selectedEntity != nil {
            NavigationLink("", isActive: $isActive) {
                SUDetailedEntity(entity: viewModel.selectedEntity!)
            }
            .frame(width: 0, height: 0)
            .hidden()
        }

        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(light)
            List(viewModel.entities) { entity in
                FavouriteListRow(entity: entity)
                    .onTapGesture {
                        viewModel.selectedEntity = entity
                        isActive = true
                    }
                    .listRowSeparator(.hidden)
                        
                // Add spacing in bottom
                if entity == viewModel.entities.last {
                    Rectangle()
                        .frame(height: 100)
                        .foregroundColor(light)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .listStyle(PlainListStyle())
        .ignoresSafeArea()
        .onAppear(perform: {
            viewModel.selectedEntity = nil
            getFavourites()
        })
        .background(Color.blue)
    }

    func getFavourites() {
        // TODO: Make this an extension on Show/Proto_game/Movie?
        if T.self == Show.self {
            let favs = UserProfileManager().favouriteShows()
            favs.forEach { showId in
                APIDAO().show(withId: showId) { show in
                    addEntity(show)
                }
            }
        } else if T.self == Movie.self {
            let favs = UserProfileManager().favouriteMovies()
            favs.forEach { movieId in
                APIDAO().movie(withId: UInt64(movieId)) { movie in
                    addEntity(movie)
                }
            }
        } else if T.self == Proto_Game.self {
            let favs = GameStore.getFavourites()
            favs.forEach { gameId in
                APIDAO().game(withId: UInt64(gameId)) { game in
                    addEntity(game)
                }
            }
        }
    }
    
    func addEntity( _ e : Entity) {
        DispatchQueue.main.async {
            let entity = e as! T
            if !self.viewModel.entities.contains(where: { existingEntity in
                existingEntity.id == entity.id
            }) {
                self.viewModel.entities.append(entity)
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
