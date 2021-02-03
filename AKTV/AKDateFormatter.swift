//
//  AKDateFormatter.swift
//  AKTV
//
//  Created by Alexander Kvamme on 02/05/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation


final class AKDateFormatter: NSObject {

    // MARK: Static function
    
    static func day(from str: String) -> DayModel? {
        let splits = str.split(separator: "-")
        guard let y = Int(splits[0]),
              let m = Int(splits[1]),
              let d = Int(splits[2]) else {
            return nil
        }

        return DayModel(day: d, month: m, year: y)
    }
}
