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
    
    // MARK: Properties
    
    // MARK: Initializers
    
    // MARK: Private methods
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    // MARK: Static methods
    
    static func date(from str: String) -> Date? {
        print("bam would try to make date from: ", str)
        return Date()
    }
}
