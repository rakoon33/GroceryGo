//
//  StorageUtils.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 17/8/25.
//

import Foundation

class Utils {
    class func UDSET(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    class func UDValue(key: String) -> Any {
        if !UserDefaults.standard.dictionaryRepresentation().keys.contains(key) {
            AppLogger.info("UserDefaults read: missing key=\(key)", category: .general)
        }
        return UserDefaults.standard.value(forKey: key) as Any
    }
    
    class func UDValueBool(key: String) -> Bool {
        if !UserDefaults.standard.dictionaryRepresentation().keys.contains(key) {
            AppLogger.info("UserDefaults read Bool: missing key=\(key)", category: .general)
        }
        return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
    
    class func UDValueTrueBool(key: String) -> Bool {
        if !UserDefaults.standard.dictionaryRepresentation().keys.contains(key) {
            AppLogger.info("UserDefaults read TrueBool: missing key=\(key)", category: .general)
        }
        return UserDefaults.standard.value(forKey: key) as? Bool ?? true
    }
    
    class func UDRemove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
