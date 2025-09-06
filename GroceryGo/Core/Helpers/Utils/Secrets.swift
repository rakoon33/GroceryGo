//
//  Secrets.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 6/9/25.
//

import Foundation

final class Secrets {
    static let shared = Secrets()

    private let dict: [String: Any]

    private init() {
        if let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
            dict = plist
        } else {
            dict = [:]
        }
    }

    func string(forKey key: String) -> String? {
        return dict[key] as? String
    }

    static func value(for key: String) -> String? {
        return Secrets.shared.string(forKey: key)
    }

    // optional helpers
    static func int(for key: String) -> Int? {
        return Secrets.shared.dict[key] as? Int
    }

    static func bool(for key: String) -> Bool? {
        return Secrets.shared.dict[key] as? Bool
    }
}
