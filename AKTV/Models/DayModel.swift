//
//  DayModel.swift
//  AKTV
//
//  Created by Alexander Kvamme on 03/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
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
