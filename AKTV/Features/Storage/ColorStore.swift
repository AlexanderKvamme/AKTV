//
//  ColorStore.swift
//  AKTV
//
//  Created by Alexander Kvamme on 26/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import ComplimentaryGradientView


final class ColorStore {

    static func clearEntries() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.hasPrefix("episode-key"){
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    private static func showOverviewKey(for overview: ShowOverview) -> String {
        guard let path = overview.posterPath else {
            fatalError("Needed stillPath to get colors")
        }
        // TODO: Use url path for a more generic color storage
        return "episode-key-\(path)"
    }
    
    static func save(_ colors: UIImageColors, forOverview overview: ShowOverview) {
        let encodableColors = UIImageColorsWrapper(background: colors.background,
                                                   detail: colors.detail,
                                                   primary: colors.primary,
                                                   secondary: colors.secondary)

        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(encodableColors)
            let episodeKey = showOverviewKey(for: overview)
            UserDefaults.standard.set(encodedData, forKey: episodeKey)
        } catch let error {
            fatalError("could not store color: \(error.localizedDescription)")
        }
    }

    static func get(colorsFrom overview: ShowOverview) -> UIImageColors? {
        let episodeKey = showOverviewKey(for: overview)
        guard let data = UserDefaults.standard.data(forKey: episodeKey) else { return nil }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(UIImageColorsWrapper.self, from: data)
            return UIImageColors(background: decodedData.background.color,
                                 primary: decodedData.primary.color,
                                 secondary: decodedData.secondary.color,
                                 detail: decodedData.detail.color)
        } catch {
            fatalError("Failed retrieving colors from userdefaults")
        }
    }
}



/// Can wrap UIImageColors objects, making them Codable and storable in userDefaults
struct UIImageColorsWrapper: Codable {
    let background: CodableColor
    let detail: CodableColor
    let primary: CodableColor
    let secondary: CodableColor

    init(background: UIColor, detail: UIColor, primary: UIColor, secondary: UIColor) {
        self.background = CodableColor(color: background)
        self.detail = CodableColor(color: detail)
        self.primary = CodableColor(color: primary)
        self.secondary = CodableColor(color: secondary)
    }
}


/// Allows you to use Swift encoders and decoders to process UIColor
public struct CodableColor {
    let color: UIColor
}

extension CodableColor: Encodable {

    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

extension CodableColor: Decodable {

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        self.color = UIColor(coder: nsCoder)!
    }
}



public extension UIColor {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}