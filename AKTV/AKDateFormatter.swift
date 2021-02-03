//
//  AKDateFormatter.swift
//  AKTV
//
//  Created by Alexander Kvamme on 02/05/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

struct DayModel: Hashable, Comparable {
    static func < (lhs: DayModel, rhs: DayModel) -> Bool {
        return Int("\(lhs.year)\(lhs.month)\(lhs.day)")! < Int("\(rhs.year)\(rhs.month)\(rhs.day)")!
    }

    var day: Int
    var month: Int
    var year: Int

}

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
