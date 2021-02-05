//
//  UpcomingSectionHeaderView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI


struct UpcomingSectionHeaderView: View {

    let date: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(date)
                .font(Font.round(.medium, 24))
                .foregroundColor(dark)
                .opacity(0.4)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(24)
        })
        .background(light)
    }
}

struct UpcomingSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpcomingSectionHeaderView(date: "13.11.86")
            UpcomingSectionHeaderView(date: "13.11.86")
        }
    }
}
