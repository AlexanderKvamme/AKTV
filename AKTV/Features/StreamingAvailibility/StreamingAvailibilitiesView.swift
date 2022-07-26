//
//  StreamingAvailibilitiesView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 26/11/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import Combine


struct StreamingAvailibilitiesView: View {
    
    var entity: Entity
    @ObservedObject var viewModel: ViewModel
    
    class ViewModel: ObservableObject {
        var subscriptions = Set<AnyCancellable>()
        @Published var streams = Array([String : [String : Country]]())
    }
    
    var body: some View {
        VStack {
            if self.$viewModel.streams.count > 0 {
                VStack {
                    Text("Streamable on:")
                        .font(Font.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    List(viewModel.streams, id: \.key) { item in
                        Text(item.key)
                    }
                }
            } else {
                EmptyView()
            }
        }.onAppear {
            fetch()
        }
    }
    
    private func fetch() {
        StreamAvailability.makePublisher(tmdbId: entity.id).sink { completion in
            // completion
        } receiveValue: { value in
            DispatchQueue.main.async {
                self.viewModel.streams = Array(value.streamingInfo)
            }
        }
        .store(in: &viewModel.subscriptions)
    }
}

