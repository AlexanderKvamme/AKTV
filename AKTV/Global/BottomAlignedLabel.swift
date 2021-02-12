//
//  BottomAlignedLabel.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class BottomAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        guard let string = text else {
            super.drawText(in: rect)
            return
        }

        let sizeOfText = (string as NSString).boundingRect(
            with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font!],
            context: nil).size

        let newYPos = rect.size.height - sizeOfText.height
        var newRect = rect
        newRect.size.height = sizeOfText.height.rounded()
        newRect.origin.y = newYPos

        super.drawText(in: newRect)
    }
}
