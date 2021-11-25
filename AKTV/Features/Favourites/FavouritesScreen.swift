//
//  FavouritesScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 31/10/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SwiftUI
import IGDB_SWIFT_API

// TODO: Make 400x64

struct AKButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.black)
            .font(.custom("Gilroy-Bold", size: 16))
            .foregroundColor(light)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}


// SwiftUI Favourites Screen
struct SUFavouritesScreen: View {

    @State var pickables = MediaPickable.allCases
    @State var selected: MediaPickable?
    @State var isLinkActive = false

    var body: some View {
        NavigationView {
            ZStack{
                Rectangle()
                    .foregroundColor(light)
                    .ignoresSafeArea()

                LazyVStack {
                    ForEach(pickables) { pickable in
                        Button(action: {
                            selected = pickable
                            isLinkActive = true
                        }) {
                            Text(pickable.rawValue)
                                .foregroundColor(light)
                        }
                        .buttonStyle(AKButton())
                        .padding(6)
                        .shadow(color: .black.opacity(0.1), radius: 14, x: 0, y: 16)
                        .listRowSeparator(.hidden)
                        
                        if selected == .tvShow {
                            NavigationLink(destination: FavouriteListView<Show>(), isActive: $isLinkActive) { EmptyView() }
                            .buttonStyle(PlainButtonStyle())
                        } else if selected == .game {
                            NavigationLink(destination: FavouriteListView<Proto_Game>(), isActive: $isLinkActive) { EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if selected == .movie {
                            NavigationLink(destination: FavouriteListView<Movie>(), isActive: $isLinkActive) { EmptyView()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

