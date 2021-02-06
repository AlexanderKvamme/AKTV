//
//  TabBarShape.swift
//  AKTV
//
//  Created by Alexander Kvamme on 06/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI


struct TabBarShape: Shape {

    var startAngle: Angle = Angle(degrees: 0)
    var endAngle: Angle = Angle(degrees: 90)
    var cornerRadius: CGFloat = 20

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        let cornerRadius: CGFloat = 40.0

        var path = Path()
        path.move(to: CGPoint(x: cornerRadius/2, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius/2, y: rect.minY + cornerRadius/2),
                    radius: cornerRadius/2,
                    startAngle: modifiedStart,
                    endAngle: modifiedEnd,
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius/2))
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius/2, y: rect.maxY - cornerRadius/2),
                    radius: cornerRadius/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius/2, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius/2, y: rect.maxY - cornerRadius/2),
                    radius: cornerRadius/2,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: -180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius/2))
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius/2, y: rect.minY + cornerRadius/2),
                    radius: cornerRadius/2,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        path.closeSubpath()

        return path
    }
}

struct TabBar: View {
    var body: some View {
        TabBarShape()
            .stroke(dark, lineWidth: 3.0)
            .frame(width: .infinity, height: 100, alignment: .bottom)
            .background(light)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
