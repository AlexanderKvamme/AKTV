//
//  TitleStore.swift
//  AKTV
//
//  Created by Alexander Kvamme on 31/07/2022.
//  Copyright © 2022 Alexander Kvamme. All rights reserved.
//

import Foundation

final class TitleStore {
    
    static func store(name: String, for showId: Int) {
        let ud = UserDefaults.standard
        let key = keyForID(showId)
        ud.set(name, forKey: key)
    }
    
    static func retrieveName(ofShow showId: Int) -> String {
        let ud = UserDefaults.standard
        let key = keyForID(showId)
        let result = ud.string(forKey: key)
        return result ?? "NA"
    }
    
    // MARK: Private
    
    private static func keyForID(_ id: Int) -> String {
        return "tv-show-name-for-id-\(id)"
    }
}
