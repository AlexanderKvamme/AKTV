//
//  UpcomingShowCellView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 04/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import Kingfisher


struct UpcomingShowCellView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center, content: {
                Image("post-stamp-2")
                    .renderingMode(.template)
                    .resizable()
                    .padding(20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 5)
                Image("test")
                    .resizable()
                    .background(Color.green)
                    .foregroundColor(.green)
                    .padding(40)
            })
            .frame(width: 200, height: 200, alignment: .center)
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text("American Gods")
                    .font(Font.gilroy(GilroyWeights.heavy, 30))
                    .textCase(.uppercase)
                    .lineLimit(nil)
                    .foregroundColor(Color.init(hex: "#3A3A3C"))
                    .lineLimit(nil)
                Text("Wednesday")
                    .font(Font.round(DINWeights.medium, 20))
                    .tracking(1)
                    .foregroundColor(Color.init(hex: "#3A3A3C"))
                    .lineLimit(nil)
                    .opacity(0.5)
                Spacer()
            }
            .padding([.top, .bottom], 10)
            Spacer()
        }
        .background(light)
    }
}

struct UpcomingShowCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpcomingShowCellView()
                .previewLayout(.fixed(width: 414, height: 200))
        }
    }
}


