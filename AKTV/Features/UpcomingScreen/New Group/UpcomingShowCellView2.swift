//
//  UpcomingShowCellView2.swift
//  AKTV
//
//  Created by Alexander Kvamme on 16/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import Kingfisher

struct UpcomingShowCellView2: View {

    var title: String
    var imageURL: String?
    var day: String
    var computedURL: URL {
        if let imageURL = imageURL, let url = URL(string: APIDAO.imageRoot+imageURL) {
            return url
        }

        return URL.createLocalUrl(forImageNamed: "default-placeholder-image")!
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .center, content: {
                Image("post-stamp")
                    .renderingMode(.template)
                    .resizable()
                    .padding(20)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 5)
                KFImage(computedURL)
                    .resizable()
                    .padding(40)
                    .clipped()
                    .aspectRatio(1, contentMode: .fill)
            })
            .frame(width: 200, height: 200, alignment: .center)
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text(title)
                    .font(Font.gilroy(GilroyWeights.heavy, 30))
                    .textCase(.uppercase)
                    .lineLimit(nil)
                    .foregroundColor(Color.init(hex: "#3A3A3C"))
                    .lineLimit(nil)
                Text(day)
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

struct UpcomingShowCellView2_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpcomingShowCellView(title: "Test", imageURL: "test", day: "Day name")
                             .previewLayout(.fixed(width: 414, height: 200))
        }
    }
}


